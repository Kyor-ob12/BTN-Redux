#!/bin/sh
# launch.sh - loads system/game config and launches emulator

##### FUNCTIONS #####
replace_placeholders() {
	# $1 = "SYSTEM" or "GAME"
	# expects variables: CORE, CORE_LIST, CPU_FREQS, CPU_CORES, CURRENT_SETTINGS_CONFIG to be set

	local prefix="$1"

	echo "Piping ${prefix} options"
	local PIPE_CORE_LIST
	local PIPE_CPU_FREQS
	local PIPE_CPU_CORES

	PIPE_CORE_LIST=$(printf "%s" "$CORE_LIST" | tr ' ' '|')
	PIPE_CPU_FREQS=$(printf "%s" "$CPU_FREQS" | tr ' ' '|')
	PIPE_CPU_CORES=$(printf "%s" "$CPU_CORES" | tr ' ' '|')

	sed -i "s#'Default'#\'$CORE\'#" "$CURRENT_SETTINGS_CONFIG"
	sed -i "s#${prefix}_CORE_LIST_PLACEHOLDER#\"$PIPE_CORE_LIST\"#g" "$CURRENT_SETTINGS_CONFIG"
	sed -i "s#${prefix}_CPU_FREQS_PLACEHOLDER#\"$PIPE_CPU_FREQS\"#g" "$CURRENT_SETTINGS_CONFIG"
	sed -i "s#${prefix}_CPU_CORES_PLACEHOLDER#\"$PIPE_CPU_CORES\"#g" "$CURRENT_SETTINGS_CONFIG"

	log_message "[DEBUG] ${prefix} placeholders replaced"
}

##### LOAD BASE VARIABLES & LIBRARIES #####
MOUNT_DIR="/mnt/SDCARD"
. $MOUNT_DIR/Emu/.emu_setup/manage_options.sh "$1" "launch.sh"
. $MOUNT_DIR/CFW/scripts/helperFunctions.sh

##### Message display variables #####
BG="$MOUNT_DIR/CFW/imgs/bg_display_text.png"
CONFIRM_IMAGE="$MOUNT_DIR/CFW/imgs/displayConfirm.png"

##### DEFINE ADVANCED SETTINGS VARIABLES #####
ADVANCED_SETTINGS_DIR="$MOUNT_DIR/Emu/.emu_setup/advanced_settings"

BIN_PATH="$ADVANCED_SETTINGS_DIR/bin"
SETTINGS_PATH="$ADVANCED_SETTINGS_DIR"
CURRENT_SETTINGS_CONFIG="$ADVANCED_SETTINGS_DIR/.tmp/current_settings_config"

MODES=""

##### DEFINE HELPER VARIABLES #####
HELPER_PATH="$ADVANCED_SETTINGS_DIR/originalSettingHelpers.sh"
SYSTEM_HELPER_PATH="$ADVANCED_SETTINGS_DIR/.tmp/systemSettingHelpers.sh"
GAME_HELPER_PATH="$ADVANCED_SETTINGS_DIR/.tmp/gameSettingHelpers.sh"

SHOW_SYSTEM_HELPER="$ADVANCED_SETTINGS_DIR/showSystem.sh"
SHOW_GAME_HELPER="$ADVANCED_SETTINGS_DIR/showGame.sh"

##### CREATE AND LOAD OVERRIDES #####
if [ ! -f "${OVR_OPT}" ]; then
	if [ -f "$SYS_OPT" ]; then
		mkdir -p "$OVR_DIR/$EMU_NAME" 2>/dev/null
		cp -f "$SYS_OPT" "${OVR_OPT}"
		log_message "[DEBUG] Current system options saved as override for ${GAME}."
	else
		log_message "[ERROR] ERROR: no system options file found for $EMU_NAME". Override could not be created.
		exit 1
	fi
fi

##### CONVERTING .OPTs to .CFGs for easyConfig binary #####
mkdir -p "$ADVANCED_SETTINGS_DIR/.tmp"
SYS_CFG="$ADVANCED_SETTINGS_DIR/.tmp/system.cfg"
GAME_CFG="$ADVANCED_SETTINGS_DIR/.tmp/game.cfg"
"$ADVANCED_SETTINGS_DIR/globals_to_cfg.sh" "${SYS_OPT}" "$SYS_CFG"
"$ADVANCED_SETTINGS_DIR/globals_to_cfg.sh" "${OVR_OPT}" "$GAME_CFG"

sed "s|^CFG_FILE=.*|CFG_FILE=\"${SYS_CFG}\"|" "$HELPER_PATH" >"$SYSTEM_HELPER_PATH"
sed "s|^CFG_FILE=.*|CFG_FILE=\"${GAME_CFG}\"|" "$HELPER_PATH" >"$GAME_HELPER_PATH"
log_message "[DEBUG] System and Game Helpers created"

# Prepare helpers to show additional info
sed "s|^CURRENT_SYSTEM=.*|CURRENT_SYSTEM=\"${EMU_NAME}\"|" "$SHOW_SYSTEM_HELPER" >"$ADVANCED_SETTINGS_DIR/.tmp/showCurrentSystem.sh"
sed "s|^CURRENT_GAME=.*|CURRENT_GAME=\"${GAME}\"|" "$SHOW_GAME_HELPER" >"$ADVANCED_SETTINGS_DIR/.tmp/showCurrentGame.sh"
CURRENT_SYSTEM_NAME="$("$ADVANCED_SETTINGS_DIR/.tmp/showCurrentSystem.sh")"
log_message "[DEBUG] System and Game show scripts modified"

##### ADVANCED SETTINGS VARIABLE SUBSTITUTION #####
cp "$SETTINGS_PATH/settings_config" "$CURRENT_SETTINGS_CONFIG"
log_message "[DEBUG] 'currentSettings' file created"

# Loading System options and replacing placeholders in currentSettingsConfig
. "${SYS_OPT}"
replace_placeholders "SYSTEM"

# Loading Game options and replacing placeholders in currentSettingsConfig
. "${OVR_OPT}"
replace_placeholders "GAME"

# Add modes, first will be Expert
MODES="$MODES -m Expert"

# Launch binary with current configs & helpers
log_message "[INFO] Advanced settings menu configured. Launching easyConfig"
cd $BIN_PATH
./easyConfig $CURRENT_SETTINGS_CONFIG $MODES
log_message "[INFO] Advanced settings menu has finished. Executing additional scripts"

# Updating .opt files with .cfg values
"$ADVANCED_SETTINGS_DIR/cfg_to_globals.sh" "$SYS_CFG" "${SYS_OPT}"
"$ADVANCED_SETTINGS_DIR/cfg_to_globals.sh" "$GAME_CFG" "${OVR_OPT}"

# This avoids unnecessary .opt files if user enters into advanced_settings without modifying anything
cd $MOUNT_DIR
if diff -q "$SYS_OPT" "${OVR_OPT}" >/dev/null; then
	log_message "[DEBUG] No differences between '$CURRENT_SYSTEM_NAME' and '${GAME}' settings."
	DISPLAY_MESSAGE="No differences between '$CURRENT_SYSTEM_NAME' and '${GAME}' settings. Do you want to delete game settings file?"

	display -i "$BG" -t "$DISPLAY_MESSAGE" -a "left" --confirm
	if confirm; then
		rm "${OVR_OPT}"
		log_message "[DEBUG] '${GAME}' settings deleted."
		display -t "'${GAME}' settings deleted." -d 3
	else
		log_message "[DEBUG] '${GAME}' settings saved."
		display -t "'${GAME}' settings saved." -d 3
	fi
fi

log_message "[DEBUG] '$CURRENT_SYSTEM_NAME' settings saved."
display -t "'$CURRENT_SYSTEM_NAME' settings saved." -d 3
