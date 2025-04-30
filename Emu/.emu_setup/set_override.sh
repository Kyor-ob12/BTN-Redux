#!/bin/sh

##### DEFINE BASE VARIABLES #####
MOUNT_DIR="/mnt/SDCARD"
#MOUNT_DIR="."

# Loading option paths & variables
. $MOUNT_DIR/Emu/.emu_setup/manage_options.sh "$1" "set_override.sh"

log_message "[INFO] remove_override.sh: --- Setting per-game launch options ---"

##### IMPORT .OPT FILES #####
if [ -f "$SYS_OPT" ]; then
	if [ ! -d "$OVR_DIR/$EMU_NAME" ]; then
		mkdir "$OVR_DIR/$EMU_NAME"
	fi
	cp -f "$SYS_OPT" "${OVR_OPT}" &
	log_message "[INFO] remove_override.sh: Current system options saved as override for ${GAME}."
	. "${OVR_OPT}"
	display -d 2 -t "Setting $CORE core, $EMU_CPU CPU MHz and $EMU_CORES CPU core(s) as override for ${GAME}."
else
	log_message "[ERROR] remove_override.sh: : No system options file found for $EMU_NAME". Override could not be created.
	display -d 2 -t "ERROR: no system options file found for $EMU_NAME. Override could not be created."
fi
