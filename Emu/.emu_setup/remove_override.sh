#!/bin/sh

##### DEFINE BASE VARIABLES #####
MOUNT_DIR="/mnt/SDCARD"
#MOUNT_DIR="."

# Loading option paths & variables
. $MOUNT_DIR/Emu/.emu_setup/manage_options.sh "$1" "remove_override.sh"

log_message "[INFO] remove_override.sh: --- Removing per-game launch options ---"

##### IMPORT .OPT FILES #####
if [ -f "${OVR_OPT}" ]; then
	rm -f "${OVR_OPT}"
	log_message "[INFO] remove_override.sh: Launch setting override removed for ${GAME}."
else
	log_message "[INFO] remove_override.sh: No override file to delete for ${GAME}."
fi
display -d 2 -t "Removed launch override from ${GAME}"
