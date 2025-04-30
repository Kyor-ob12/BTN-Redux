#!/bin/sh

##### DEFINE BASE VARIABLES #####
MOUNT_DIR="/mnt/SDCARD"
#MOUNT_DIR="."

# Libraries
. $MOUNT_DIR/CFW/scripts/helperFunctions.sh

# Message display variables
BG="$MOUNT_DIR/CFW/imgs/bg_display_text.png"
LOG_FILE="$MOUNT_DIR/CFW/btn.log"

> ${LOG_FILE}

DISPLAY_MESSAGE="${LOG_FILE} cleaned"

display -i "$BG" -a "left" -t "$DISPLAY_MESSAGE" -d 3