#!/bin/sh
MOUNT_DIR="/mnt/SDCARD"

# Loading option paths & variables
. $MOUNT_DIR/Emu/.emu_setup/manage_options.sh "$1" "cpu_cores_switch.sh"

# Trying to load GAME override options overwritting System options
if [ -f "${OVR_OPT}" ]; then
	. "${OVR_OPT}"
else
	. "${SYS_OPT}";
fi

NEW_EMU_CORES=$(get_next_item "$EMU_CORES" "$CPU_CORES")
NEW_DISPLAY=$(get_selected_item_display "$NEW_EMU_CORES" "$CPU_CORES")

# Message display variables
BG="$MOUNT_DIR/CFW/imgs/bg_display_text.png"
DISPLAY_MESSAGE="CPU Mode changed to $NEW_EMU_CORES core(s)
- Emulator/core: $CORE
- CPU: $EMU_CPU Mhz / $NEW_EMU_CORES core(s)"

log_message "[INFO] cpu_cores_switch.sh: Changing $EMU_NAME cpu cores from $EMU_CORES to $NEW_EMU_CORES"

if [ ! -f "${OVR_OPT}" ]; then
	sed -i "s|\"CPU Cores:.*\"|\"CPU Cores: $NEW_DISPLAY\"|g" "$CONFIG"
	sed -i "s|EMU_CORES=.*|EMU_CORES=$NEW_EMU_CORES|g" "$SYS_OPT"
	DISPLAY_MESSAGE="*""${EMU_NAME}""*"$'\n'"$DISPLAY_MESSAGE"
else
	sed -i "s|EMU_CORES=.*|EMU_CORES=$NEW_EMU_CORES|g" "${OVR_OPT}"
	DISPLAY_MESSAGE="*""${GAME}""*"$'\n'"$DISPLAY_MESSAGE"
fi

display -i "$BG" -t "$DISPLAY_MESSAGE" -a "left"

sleep 2
