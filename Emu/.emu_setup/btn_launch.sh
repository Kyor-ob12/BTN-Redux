#!/bin/sh
# One Emu launch.sh to rule them all!
# Ry 2024-09-24


##### DEFINE BASE VARIABLES #####
MOUNT_DIR="/mnt/SDCARD"
#MOUNT_DIR="."

##### IMPORT .OPT FILES #####
# Loading option paths & variables
. $MOUNT_DIR/Emu/.emu_setup/manage_options.sh "$1" "btn_launch.sh"

# loading game override .opt overwritting previous values
if [ -f "${OVR_OPT}" ]; then
	. "${OVR_OPT}";
	log_message "[INFO] btn_launch.sh: Game options file detected: ${OVR_OPT}"
else
	. "${SYS_OPT}";
	log_message "[INFO] btn_launch.sh: Game options file not found. Using current system settings."
fi

# we sanitise the rom path
ROM_FILE="$(readlink -f "$1")"

##### LAUNCHING EMULATOR #####
log_message "[INFO] btn_launch.sh: -----Launching Emulator-----"
log_message "[INFO] btn_launch.sh: trying: $0 $@"

case "$EMU_NAME" in
    NDS)
        # Load using custom launch.sh and hardcoded options
        cd "$EMU_DIR"
        . "$EMU_DIR/launch.sh" "$1"
        ;;
    PSP)
        # PSP using PPSSPP standalone emulator
        log_message "[DEBUG] btn_launch.sh: Executing ${EMU_NAME}(${CORE}): ${GAME} ($EMU_CORES core(s) at ${EMU_CPU}Mhz)"
        . "$STANDALONE_DIR/ppsspp.sh" "$1"
        ;;
	PORTS)
        log_message "[DEBUG] btn_launch.sh: Executing ${EMU_NAME}(${CORE}): ${GAME} ($EMU_CORES core(s) at ${EMU_CPU}Mhz)"
        cpuclock performance "$EMU_CORES" "$EMU_CPU" "$GPU_MHZ"
		PORTS_DIR=/mnt/SDCARD/Roms/PORTS
		cd $PORTS_DIR
		/bin/sh "$ROM_FILE"
		;;
	OPENBOR)
        log_message "[DEBUG] btn_launch.sh: Executing ${EMU_NAME}(${CORE}): ${GAME} ($EMU_CORES core(s) at ${EMU_CPU}Mhz)"
        cpuclock performance "$EMU_CORES" "$EMU_CPU" "$GPU_MHZ"
		export LD_LIBRARY_PATH=lib:/usr/miyoo/lib:/usr/lib
		export HOME=$EMU_DIR
		cd $HOME
		if [ "$GAME" == "Final Fight LNS.pak" ]; then
			./OpenBOR_mod "$ROM_FILE"
		else
			./OpenBOR_new "$ROM_FILE"
		fi
		sync
		;;
    *)
        case "$CORE" in
            pocketSNES)
                # SNES/SFC using PocketSNES standalone emulator
                log_message "[DEBUG] btn_launch.sh: Executing ${EMU_NAME}(${CORE}): ${GAME} ($EMU_CORES core(s) at ${EMU_CPU}Mhz)"
                . "$STANDALONE_DIR/pocketSNES.sh" "$1"
                ;;
            picodrive_standalone)
                log_message "[DEBUG] btn_launch.sh: Executing ${EMU_NAME}(${CORE}): ${GAME} ($EMU_CORES core(s) at ${EMU_CPU}Mhz)"
                # GG, MS, MD, SEGACD or SEGA32X using PicoDrive standalone emulator
                . "$STANDALONE_DIR/picoDrive.sh" "$1"
                ;;
            *)
                # Default: Load using RetroArch
                RA_BIN="ra32.miyoo"
                RA_DIR="$MOUNT_DIR/RetroArch"
                cd "$RA_DIR"

                # Reset CORE_PATH
                CORE_PATH=""

                for path in \
                    "$EMU_DIR/${CORE}.so" \
                    "$EMU_DIR/${CORE}_libretro.so" \
                    "$RA_DIR/.retroarch/cores/${CORE}.so" \
                    "$RA_DIR/.retroarch/cores/${CORE}_libretro.so"
                do
                    if [ -f "$path" ]; then
                        CORE_PATH="$path"
                        break
                    fi
                done

                # If no path was found
                if [ -z "$CORE_PATH" ]; then
                    log_message "[ERROR] btn_launch.sh: ${CORE} option does not match any core/emulator!"
                    exit 1
                fi

                log_message "[DEBUG] btn_launch.sh: Executing ${EMU_NAME}(${CORE}): ${GAME} ($EMU_CORES core(s) at ${EMU_CPU}Mhz)"
                echo "$0 $*"
                cpuclock performance "$EMU_CORES" "$EMU_CPU" "$GPU_MHZ"

                HOME="$RA_DIR/" "$RA_DIR/$RA_BIN" -v -L "$CORE_PATH" "$ROM_FILE"
                ;;
        esac
        ;;
esac
