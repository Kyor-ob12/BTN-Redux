#!/bin/sh
MOUNT_DIR="/mnt/SDCARD"

# Loading option paths & variables
. $MOUNT_DIR/Emu/.emu_setup/manage_options.sh "$1" "cpu_switch.sh"

# Trying to load GAME override options overwritting System options
if [ -f "${OVR_OPT}" ]; then
	. "${OVR_OPT}"
else
	. "${SYS_OPT}";
fi

NEW_CORE=$(get_next_item "$CORE" "$CORE_LIST")
NEW_DISPLAY=$(get_selected_item_display "$NEW_CORE" "$CORE_LIST")

# Message display variables
BG="$MOUNT_DIR/CFW/imgs/bg_display_text.png"
DISPLAY_MESSAGE="Emulator/Core changed to $NEW_CORE
- Emulator/core: $NEW_CORE
- CPU: $EMU_CPU Mhz / $EMU_CORES core(s)"

log_message "[INFO] core_switch.sh: Changing $EMU_NAME core from $CORE to $NEW_CORE"

if [ ! -f "${OVR_OPT}" ]; then
	sed -i "s|\"Emu Core:.*\"|\"Emu Core: $NEW_DISPLAY\"|g" "$CONFIG"
	sed -i "s|CORE=.*|CORE=\"$NEW_CORE\"|g" "$SYS_OPT"
	DISPLAY_MESSAGE="*""${EMU_NAME}""*"$'\n'"$DISPLAY_MESSAGE"
else
	sed -i "s|CORE=.*|CORE=\"$NEW_CORE\"|g" "${OVR_OPT}"
	DISPLAY_MESSAGE="*""${GAME}""*"$'\n'"$DISPLAY_MESSAGE"
fi

display -i "$BG" -t "$DISPLAY_MESSAGE" -a "left"

sleep 2
