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

NEW_EMU_CPU=$(get_next_item "$EMU_CPU" "$CPU_FREQS")
NEW_DISPLAY=$(get_selected_item_display "$NEW_EMU_CPU" "$CPU_FREQS")

# Message display variables
BG="$MOUNT_DIR/CFW/imgs/bg_display_text.png"
DISPLAY_MESSAGE="CPU Mode changed to $NEW_EMU_CPU Mhz
- Emulator/core: $CORE
- CPU: $NEW_EMU_CPU Mhz / $EMU_CORES core(s)"

log_message "[INFO] cpu_switch.sh: Changing $EMU_NAME  cpu mode from $EMU_CPU to $NEW_EMU_CPU Mhz"

if [ ! -f "${OVR_OPT}" ]; then
	sed -i "s|\"CPU Mode:.*\"|\"CPU Mode: $NEW_DISPLAY\"|g" "$CONFIG"
	sed -i "s|EMU_CPU=.*|EMU_CPU=$NEW_EMU_CPU|g" "$SYS_OPT"
	DISPLAY_MESSAGE="*""${EMU_NAME}""*"$'\n'"$DISPLAY_MESSAGE"
else
	sed -i "s|EMU_CPU=.*|EMU_CPU=$NEW_EMU_CPU|g" "${OVR_OPT}"
	DISPLAY_MESSAGE="*""${GAME}""*"$'\n'"$DISPLAY_MESSAGE"
fi

display -i "$BG" -t "$DISPLAY_MESSAGE" -a "left"

sleep 2
