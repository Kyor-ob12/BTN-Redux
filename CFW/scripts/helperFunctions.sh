# Function summaries:

# acknowledge: Waits for user to press A, B, or Start button
# display: Displays text on the screen with various options
# get_current_theme: Unlocks dynamic variables for fast access to assets of current theme
# get_current_theme_path: Returns path of the current theme
# log_message: Logs a message to a file
# log_precise: Logs messages with greater precision for performance testing
# log_verbose: Turns on or off verbose logging for debug purposes

# This is a collection of functions that are used in multiple scripts
# Please do not add any dependencies here, this file is meant to be self-contained
# Keep methods in alphabetical order

# Gain access to the helper variables by adding this to the top of your script:
# . /mnt/SDCARD/CFW/scripts/helperFunctions.sh


# Detect device and export to any script sourcing helperFunctions
INFO=$(cat /proc/cpuinfo 2> /dev/null)
case $INFO in
*"sun8i"*)
	if [ -d /usr/miyoo ]; then
		export PLATFORM="A30"
	else
		export PLATFORM="Smart"
	fi
	;;
*"SStar"*)
	export PLATFORM="MiyooMini"
	;;
*"TG5040"*)
	export PLATFORM="SmartPro"
	;;
*"TG3040"*)
	export PLATFORM="Brick"
	;;
*)
    export PLATFORM="A30"
    ;;
esac

DISPLAY_TEXT_FILE="/mnt/SDCARD/CFW/display_text.elf"

# Key exports so we can refer to buttons by more memorable names
if [ "$PLATFORM" = "A30" ]; then
    export B_LEFT="key 1 105"
    export B_RIGHT="key 1 106"
    export B_UP="key 1 103"
    export B_DOWN="key 1 108"

    export B_A="key 1 57"
    export B_B="key 1 29"
    export B_X="key 1 42"
    export B_Y="key 1 56"

    export B_L1="key 1 15"
    export B_L2="key 1 18"
    export B_R1="key 1 14"
    export B_R2="key 1 20"

    export B_START="key 1 28"
    export B_START_2="enter_pressed" # only registers 0 on release, no 1 on press
    export B_SELECT="key 1 97"
    export B_SELECT_2="rctrl_pressed"

    export B_VOLUP="volume up"       # only registers on press and on change, not on release. No 1 or 0.
    export B_VOLDOWN="key 1 114"     # has actual key codes like the buttons
    export B_VOLDOWN_2="volume down" # only registers on change. No 1 or 0.
    export B_MENU="key 1 1"          # surprisingly functions like a regular button

elif [ "$PLATFORM" = "Brick" ]; then
    export B_LEFT="key 3 16 -1"  # negative for left
    export B_RIGHT="key 3 17 1"  # positive for right
    export B_UP="key 3 17 -1"    # negative for up
    export B_DOWN="key 3 17 1"   # positive for down

    export STICK_LEFT="key 3 0 -32767" # negative for left
    export STICK_RIGHT="key 3 0 32767" # positive for right
    export STICK_UP="key 3 1 -32767"   # negative for up
    export STICK_DOWN="key 3 1 32767"  # positive for down

    export B_A="key 1 305"
    export B_B="key 1 304"
    export B_X="key 1 308"
    export B_Y="key 1 307"

    export B_L1="key 1 310"
    export B_L2="key 3 2 255" # 255 on push, nothing on release...
    export B_R1="key 1 311"
    export B_R2="key 3 5 255" # 255 on push, nothing on release...

    export B_L3="key 1 317" # also logs left fnkey stuff
    export B_R3="key 1 318" # also logs right fnkey stuff

    export B_START="key 1 315"
    export B_START_2="start_pressed" # only registers 0 on release, no 1.
    export B_SELECT="key 1 314"
    export B_SELECT_2="select_pressed" # registers both 1 and 0

    export B_VOLUP="key 1 115" # has actual key codes like the buttons
    export B_VOLDOWN="key 1 114" # has actual key codes like the buttons
    export B_VOLDOWN_2="volume down" # only registers 0 on release, no 1.
    export B_MENU=""key 1 316""
fi

# Call this just by having "acknowledge" in your script
# This will pause until the user presses the A, B, or Start button
acknowledge() {
    # These echo's are needed to seperate the events in the key press log file
    local messages_file="/var/log/messages"
    echo "ACKNOWLEDGE $(date +%s)" >>"$messages_file"

    while true; do
        inotifywait "$messages_file"
        last_line=$(tail -n 1 "$messages_file")
        case "$last_line" in
        *"$B_START_2"* | *"$B_A"* | *"$B_B"*)
            echo "ACKNOWLEDGED $(date +%s)" >>"$messages_file"
            log_message "last_line: $last_line" -vS
            break
            ;;
        esac
    done
}

# Call this to wait for the user to confirm an action
# Use this with display --confirm to show an image with a confirm/cancel prompt
# The combined usage would be like

# display -t "Do you want to do this?" --confirm
# if confirm; then
#     display -t "You confirmed the action" -d 3
# else
#     log_message "User did not confirm" -v
#     display -t "You did not confirm the action" -d 3
# fi
confirm() {
    local messages_file="/var/log/messages"
    local timeout=${1:-0}        # Default to 0 (no timeout) if not provided
    local timeout_return=${2:-1} # Default to 1 if not provided
    local start_time=$(date +%s)

    echo "CONFIRM $(date +%s)" >>"$messages_file"

    while true; do
        # Check for timeout first
        if [ $timeout -ne 0 ]; then
            local current_time=$(date +%s)
            local elapsed_time=$((current_time - start_time))
            if [ $elapsed_time -ge $timeout ]; then
                display_kill
                echo "CONFIRM TIMEOUT $(date +%s)" >>"$messages_file"
                return $timeout_return
            fi
        fi

        # Wait for log message update (with a shorter timeout to allow frequent timeout checks)
        if ! inotifywait -t 1 "$messages_file" >/dev/null 2>&1; then
            continue
        fi

        # Get the last line of log file
        last_line=$(tail -n 1 "$messages_file")
        case "$last_line" in
        # B button - cancel
        *"key 1 29"*)
            display_kill
            echo "CONFIRM CANCELLED $(date +%s)" >>"$messages_file"
            return 1
            ;;
        # A button - confirm
        *"key 1 57"*)
            display_kill
            echo "CONFIRM CONFIRMED $(date +%s)" >>"$messages_file"
            return 0
            ;;
        esac
    done
}

DEFAULT_IMAGE="/mnt/SDCARD/CFW/imgs/displayText.png"
ACKNOWLEDGE_IMAGE="/mnt/SDCARD/CFW/imgs/displayAcknowledge.png"
CONFIRM_IMAGE="/mnt/SDCARD/CFW/imgs/displayConfirm.png"
DEFAULT_FONT="/mnt/SDCARD/CFW/nunwen.ttf"
# Call this to display text on the screen
# IF YOU CALL THIS YOUR SCRIPT NEEDS TO CALL display_kill()
# It's possible to leave a display process running
# Usage: display [options]
# Options:
#   -i, --image <path>    Image path (default: DEFAULT_IMAGE)
#   -t, --text <text>     Text to display
#   -d, --delay <seconds> Delay in seconds (default: 0)
#   -s, --size <size>     Text size (default: 36)
#   -p, --position <pos>  Text position in pixels from the top of the screen
#   (Text is offset from it's center, images are offset from the top of the image)
#   -a, --align <align>   Text alignment (left, middle, right) (default: middle)
#   -w, --width <width>   Text width (default: 600)
#   -c, --color <color>   Text color in RGB format (default: dbcda7) Spruce text yellow
#   -f, --font <path>     Font path (optional)
#   -o, --okay            Use ACKNOWLEDGE_IMAGE instead of DEFAULT_IMAGE and runs acknowledge()
#   -bg, --bg-color <color> Background color in RGB format (default: 7f7f7f)
#   -bga, --bg-alpha <alpha> Background alpha value (0-255, default: 0)
#   -is, --image-scaling <scale> Image scaling factor (default: 1.0)
# Example: display -t "Hello, World!" -s 48 -p top -a center -c ff0000
# Calling display with -o/--okay will use the ACKNOWLEDGE_IMAGE instead of DEFAULT_IMAGE
# Calling display with --confirm will use the CONFIRM_IMAGE instead of DEFAULT_IMAGE
# If using --confirm, you should call the confirm() message in an if block in your script
# --confirm will supercede -o/--okay
# You can also call infinite image layers with (next-image.png scale height side)*
#   --icon <path>         Path to an icon image to display on top (default: none)
# Example: display -t "Hello, World!" -s 48 -p top -a center -c ff0000 --icon "/path/to/icon.png"

display() {
    local image="$DEFAULT_IMAGE" text=" " delay=0 size=30 position=210 align="middle" width=600 color="ffffff" font=""
    local use_acknowledge_image=false
    local use_confirm_image=false
    local run_acknowledge=false
    local bg_color="7f7f7f" bg_alpha=0 image_scaling=1.0
    local icon_image=""
    local additional_images=""
    local position_set=false
    local qr_url=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--image) image="$2"; shift ;;
            -t|--text) text="$2"; shift ;;
            -d|--delay) delay="$2"; shift ;;
            -s|--size) size="$2"; shift ;;
            -p|--position) position="$2"; position_set=true; shift ;;
            -a|--align) align="$2"; shift ;;
            -w|--width) width="$2"; shift ;;
            -c|--color) color="$2"; shift ;;
            -f|--font) font="$2"; shift ;;
            -o|--okay) use_acknowledge_image=true; run_acknowledge=true ;;
            --confirm) use_confirm_image=true; use_acknowledge_image=false; run_acknowledge=false ;;
            -bg|--bg-color) bg_color="$2"; shift ;;
            -bga|--bg-alpha) bg_alpha="$2"; shift ;;
            -is|--image-scaling) image_scaling="$2"; shift ;;
            --icon)
                icon_image="$2"
                if ! $position_set; then
                    position=$((position + 80))
                fi
                shift
                ;;
            --add-image)
                additional_images="$additional_images \"$2\" $3 $4 $5"
                shift 4
                ;;
            --qr)
                qr_url="$2"
                if ! $position_set; then
                    position=$((position + 85))
                fi
                shift
                ;;
            *) log_message "Unknown option: $1"; return 1 ;;
        esac
        shift
    done
    local r="${color:0:2}"
    local g="${color:2:2}"
    local b="${color:4:2}"
    local bg_r="${bg_color:0:2}"
    local bg_g="${bg_color:2:2}"
    local bg_b="${bg_color:4:2}"

    # Set font to DEFAULT_FONT if it's empty
    if [ -z "$font" ]; then
        font="$DEFAULT_FONT"
    fi

    # Construct the command
    local command="$DISPLAY_TEXT_FILE \"$image\" \"$text\" $delay $size $position $align $width $r $g $b \"$font\" $bg_r $bg_g $bg_b $bg_alpha $image_scaling"

    # Add icon image if specified
    if [ -n "$icon_image" ]; then
        command="$command \"$icon_image\" 0.20 160 middle"
    fi

    # Add CONFIRM_IMAGE if --confirm flag is used, otherwise use ACKNOWLEDGE_IMAGE if --okay flag is used
    if [[ "$use_confirm_image" = true ]]; then
        command="$command \"$CONFIRM_IMAGE\" 1.0 240 middle"
        delay=0
    elif [[ "$use_acknowledge_image" = true ]]; then
        command="$command \"$ACKNOWLEDGE_IMAGE\" 1.0 240 middle"
    fi

    # Add additional images
    if [ -n "$additional_images" ]; then
        command="$command $additional_images"
    fi

    # Generate QR code if --qr flag is used
    if [ -n "$qr_url" ]; then
        qr_image=$(qr_code -t "$qr_url")
        if [ -n "$qr_image" ]; then
            command="$command \"$qr_image\" 0.50 140 middle"
        else
            log_message "Failed to generate QR code for URL: $qr_url" -v
        fi
    fi

    display_kill

    # Execute the command in the background if delay is 0
    if [[ "$delay" -eq 0 ]]; then
        eval "$command" &
        log_message "display command: $command" -v
        # Run acknowledge if -o or --okay was used and --confirm was not used
        if [[ "$run_acknowledge" = true && "$use_confirm_image" = false ]]; then
            acknowledge
        fi
    else
        # Execute the command and capture its output
        eval "$command"
        log_message "display command: $command" -v
    fi
}

# Call this to kill any display processes left running
# If you use display() at all you need to call this on all the possible exits of your script
display_kill() {
    kill -9 $(pgrep display)
}

# Returns the path of the current theme
# Use by doing        theme_path=$(get_current_theme_path)
# Use files inside themes to make your apps!
get_current_theme_path() {
    local config_file="/config/system.json"

    # Check if config file exists
    if [ ! -f "$config_file" ]; then
        echo "Error: Configuration file not found at $config_file"
        return 1
    fi

    # Extract "theme" from JSON, ignoring errors
    local theme_name
    theme_name=$(jq -r 'if .theme then .theme else "" end' "$config_file")

    # If "theme" is empty
    if [ -z "$theme_name" ]; then
        echo "Error: Could not retrieve theme name from $config_file"
        return 1
    fi

    echo "$theme_name"
}

# To support themes in your apps do         [   eval "$(get_current_theme)"    ]
# Doing this will unlock dynamic variables that will give you fast access to some
# common theme files and values. These dynamic variable are: $THEME_PATH, $THEME_BG etc.
#
# Code example:
#
# eval "$(get_current_theme)"
# echo "Current theme path:         $THEME_PATH"
# echo "Background image path:      $THEME_BG"
# echo "Font path:                  $THEME_FONT"
# echo "Font size:                  $THEME_FONT_SIZE"
# echo "Font color:                 $THEME_FONT_COLOR"
# echo "Left arrow icon:            $THEME_LEFT"
# echo "Right arrow icon:           $THEME_RIGHT"
# echo "Logo:                       $THEME_LOGO"
# echo "OK icon:                    $THEME_OK"
# echo "Home button icon:           $THEME_HOME"
# echo "A button icon:              $THEME_A"
# echo "B button icon:              $THEME_B"
# echo "L2 button icon:             $THEME_L2"
# echo "R2 button icon:             $THEME_R2"
# echo "X button icon:              $THEME_X"
# echo "Y button icon:              $THEME_Y"
# echo "START button icon:          $THEME_START"
# echo "Information icon:           $THEME_INFO"
# echo "Folder icon:                $THEME_FOLDER"
# echo "SD/TF card icon:            $THEME_SD"
# echo "Wifi icon:                  $THEME_WIFI"
# echo "Shutdown icon:              $THEME_SHUTDOWN"
# echo "Reset icon:                 $THEME_RESET"
# echo "Star icon:                  $THEME_STAR"
# echo "Expert Apps icon:           $THEME_EXPERT_APPS"
get_current_theme() {
    # gets current theme path
    local theme_path
    theme_path=$(get_current_theme_path)
    local json_path
    json_path="$theme_path/config.json"

    # checks if path exists
    if [ -d "$theme_path" ]; then
        # Export theme paths
        echo "THEME_PATH=\"$theme_path\""
        echo "THEME_BG=\"$theme_path/skin/background.png\""
        echo "THEME_LEFT=\"$theme_path/skin/icon-left-arrow-24.png\""
        echo "THEME_RIGHT=\"$theme_path/skin/icon-right-arrow-24.png\""
        echo "THEME_LOGO=\"$theme_path/skin/app-loading-05.png\"" #need to discuss this
        echo "THEME_OK=\"$theme_path/skin/icon-OK.png\""
        echo "THEME_HOME=\"$theme_path/skin/ic-MENU.png\""
        echo "THEME_A=\"$theme_path/skin/icon-A-54.png\""
        echo "THEME_B=\"$theme_path/skin/icon-B-54.png\""
        echo "THEME_L2=\"$theme_path/skin/icon-L2.png\""
        echo "THEME_R2=\"$theme_path/skin/icon-R2.png\""
        echo "THEME_X=\"$theme_path/skin/icon-x.png\""
        echo "THEME_Y=\"$theme_path/skin/icon-y.png\""
        echo "THEME_START=\"$theme_path/skin/icon-START.png\""
        echo "THEME_INFO=\"$theme_path/skin/icon-device-info-48.png\""
        echo "THEME_FOLDER=\"$theme_path/skin/icon-folder.png\""
        echo "THEME_SD=\"$theme_path/skin/icon-TF.png\""
        echo "THEME_WIFI=\"$theme_path/skin/icon-setting-wifi.png\""
        echo "THEME_SHUTDOWN=\"$theme_path/skin/icon-Shutdown.png\""
        echo "THEME_RESET=\"$theme_path/skin/icon-factory-reset-48.png\""
        echo "THEME_STAR=\"$theme_path/skin/nav-favorite-f.png\""
        echo "THEME_EXPERT_APPS=\"$theme_path/icons/App/expertappswitch.png\""

        # Extract values from config JSON using jq
        if [ -f "$json_path" ]; then
            THEME_FONT_TITLE=$(jq -r '.list.font' "$json_path")
            THEME_FONT="$theme_path/$THEME_FONT_TITLE"
            THEME_FONT_SIZE=$(jq -r '.list.size' "$json_path")
            THEME_FONT_COLOR=$(jq -r '.list.color' "$json_path")

            echo "THEME_FONT=\"$THEME_FONT\""
            echo "THEME_FONT_SIZE=\"$THEME_FONT_SIZE\""
            echo "THEME_FONT_COLOR=\"$THEME_FONT_COLOR\""
        else
            echo "Error: JSON config file not found at $json_path."
            return 1
        fi
    else
        echo "Error: theme located in $theme_path doesn't exist."
        return 1
    fi
}

#
#       restore_theme()
#
# This function returns the user's theme path if it's not the default theme
# Meant to be used on installations and updates only
get_theme_path_to_restore(){
    # Get the current theme path
    local current_theme_path=$(get_current_theme_path)
    local spruce_theme="/mnt/SDCARD/Themes/SPRUCE/"
    local default_theme="../res/"

    # if the current theme is equal to the default miyoo theme
    if [[ "$current_theme_path" == "$default_theme" ]]; then # that's ugly!
        echo "$spruce_theme"                                 # Switch to the spruce theme ASAP

    else # If not, give back the user his loved theme <3
        echo "$current_theme_path"
    fi
}

# Call this to toggle verbose logging
# After this is called, any log_message calls will output to the log file if -v is passed
# USE THIS ONLY WHEN DEBUGGING, IT WILL GENERATE A LOT OF LOG FILE ENTRIES
# Remove it from your script when done.
# Can be used as a toggle: calling it once enables verbose logging, calling it again disables it
log_verbose() {
    local calling_script=$(basename "$0")
    if flag_check "log_verbose"; then
        flag_remove "log_verbose"
        log_message "Verbose logging disabled in script: $calling_script"
    else
        flag_add "log_verbose"
        log_message "Verbose logging enabled in script: $calling_script"
    fi
}

# Call this like:
# log_message "Your message here"
# To output to a custom log file, set the variable within your script:
# log_file="/mnt/SDCARD/App/MyApp/spruce.log"
# This will log the message to the spruce.log file in the Saves/spruce folder
#
# Usage examples:
# Log a regular message:
#    log_message "This is a regular log message"
# Log a verbose message (only logged if log_verbose was called):
#    log_message "This is a verbose log message" -v
# Log to a custom file:
#    log_message "Custom file log message" "" "/path/to/custom/log.file"
# Log a verbose message to a custom file:
#    log_message "Verbose custom file log message" -v "/path/to/custom/log.file"
log_file="/mnt/SDCARD/CFW/btn.log"
log_message() {
    local message="$1"
    local verbose_flag="$2"
    local custom_log_file="${3:-$log_file}"

    # Check if it's a verbose message and if verbose logging is not enabled
    #[ "$verbose_flag" = "-v" ] && ! flag_check "log_verbose" && return

    # Handle custom log file
    if [ "$custom_log_file" != "$log_file" ]; then
        mkdir -p "$(dirname "$custom_log_file")"
        touch "$custom_log_file"
    fi

    printf '%s%s - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "${verbose_flag:+ -v}" "$message" | tee -a "$custom_log_file"
}

log_precise() {
    local message="$1"
    local date_part=$(date '+%Y-%m-%d %H:%M:%S')
    local uptime_part=$(cut -d ' ' -f 1 /proc/uptime)
    local timestamp="${date_part}.${uptime_part#*.}"
    printf '%s %s\n' "$timestamp" "$message" >>"$log_file"
}

# Generate a QR code
# Usage: qr_code -t "text" -s "size" -l "level" -o "output"
# If no output is provided, the QR code will be saved to /tmp/tmp/qr.png
#   QR_CODE=$(qr_code -t "https://www.google.com")
#   display -i "$QR_CODE" -t "DT: QR Code" -d 5
QRENCODE_PATH="/mnt/SDCARD/miyoo/app/qrencode"
qr_code() {
    local text=""
    local size=3
    local level="M"
    local output="/mnt/SDCARD/spruce/tmp/qr.png"

    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -t|--text) text="$2"; shift ;;
            -s|--size) size="$2"; shift ;;
            -l|--level) level="$2"; shift ;;
            -o|--output) output="$2"; shift ;;
            *) text="$1" ;;  # If no flag, assume it's the text
        esac
        shift
    done

    # Ensure text is provided
    if [ -z "$text" ]; then
        log_message "QR Code error: No text provided" -v
        return 1
    fi

    # Make tmp directory if it doesn't exist
    mkdir -p "/mnt/SDCARD/spruce/tmp"

    # Generate QR code
    if "$QRENCODE_PATH" -o "$output" -s "$size" -l "$level" -m 2 "$text" >/dev/null 2>&1; then
        echo "$output"
        return 0
    else
        log_message "QR Code generation failed"
        echo ""
        return 1
    fi
}

read_only_check() {
    if [ $(mount | grep SDCARD | cut -d"(" -f 2 | cut -d"," -f1 ) == "ro" ]; then
        log_message "SDCARD is mounted read-only, remounting as read-write"
        mount -o remount,rw /dev/mmcblk0p1 /mnt/SDCARD
        log_message "SDCARD remounted as read-write"
    fi
}
