#!/bin/sh
MOUNT_DIR="/mnt/SDCARD"

# System & Game variables
export EMU_NAME="$(echo "$1" | cut -d'/' -f5)"
export GAME="$(basename "$1")"
export EMU_DIR="$MOUNT_DIR/Emu/${EMU_NAME}"
export CUSTOM_DEF_OPT="$EMU_DIR/default.opt"

# Ensure EMU_NAME is ok
if [ ! -f "$MOUNT_DIR/Emu/.emu_setup/defaults/${EMU_NAME}.opt" ]; then 
	export EMU_NAME="$(echo "$1" | cut -d'/' -f9)"
fi

# Config file
export CONFIG="$MOUNT_DIR/Emu/${EMU_NAME}/config.json"

# Paths
export SETUP_DIR="$MOUNT_DIR/Emu/.emu_setup"
export STANDALONE_DIR="$SETUP_DIR/standalone_emus"
export DEF_DIR="$SETUP_DIR/defaults"
export OPT_DIR="$SETUP_DIR/options"
export OVR_DIR="$SETUP_DIR/overrides"

# Option files
export A30_OPT="$DEF_DIR/A30.opt"
export DEF_OPT="$DEF_DIR/${EMU_NAME}.opt"
export SYS_OPT="$OPT_DIR/${EMU_NAME}.opt"
export OVR_OPT="$OVR_DIR/${EMU_NAME}/${GAME}.opt"

# Libraries
. $MOUNT_DIR/CFW/scripts/helperFunctions.sh
. $MOUNT_DIR/Emu/.emu_setup/emu_helper_functions.sh

# Log variables
SCRIPT="${2:-manage_options.sh}"

log_message "[INFO] $SCRIPT: Common variables and .opt paths loaded"
log_message "[DEBUG] $SCRIPT: Received parameter 1 -> ${1}"
log_message "[DEBUG] $SCRIPT: EMU_NAME ${EMU_NAME}"
log_message "[DEBUG] $SCRIPT: GAME ${GAME}"

MANAGE_OPTIONS_OUTPUT_MESSAGE=""

# Loading A30 cross system default values
if [ -f "$A30_OPT" ]; then
	. "$A30_OPT"
	MANAGE_OPTIONS_OUTPUT_MESSAGE="Default options file ${A30_OPT} variables lodaded"
else
	log_message "[WARN] $SCRIPT: Default options file ${A30_OPT} not found!"
fi

# Loading system defaults as failover .opt
if [ -f "$DEF_OPT" ]; then
	. "$DEF_OPT"
	MANAGE_OPTIONS_OUTPUT_MESSAGE="Default options file ${DEF_OPT} variables lodaded"
elif [ -f "$CUSTOM_DEF_OPT" ]; then
	. "$CUSTOM_DEF_OPT"
	MANAGE_OPTIONS_OUTPUT_MESSAGE="Custom default options file ${CUSTOM_DEF_OPT} lodaded"
else
	log_message "[WARN] $SCRIPT: Default options file ${DEF_OPT} not found!"
fi

# Trying to create system option file if it doesn't exist
if [ ! -f "$SYS_OPT" ]; then
	if [ -f "$DEF_OPT" ]; then
		mkdir -p "$MOUNT_DIR/Emu/.emu_setup/options" 2>/dev/null
		cp "$DEF_OPT" "$SYS_OPT"
		log_message "[INFO] $SCRIPT: created $SYS_OPT by copying $DEF_OPT"
	else
		log_message "[ERROR] $SCRIPT: System options file nor default options file found for $EMU_NAME"
		exit 1
	fi
fi

log_message "[INFO] $SCRIPT: ${MANAGE_OPTIONS_OUTPUT_MESSAGE}"