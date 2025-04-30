#!/bin/sh
cpuclock performance $EMU_CORES $EMU_CPU $GPU_MHZ
echo $0 $*

ROM_FILE="$(readlink -f "$1")"
GAME="$(basename "$1")"

export LD_LIBRARY_PATH=lib:/usr/miyoo/lib:/usr/lib
export HOME=$EMU_DIR
cd $HOME
if [ "$GAME" == "Final Fight LNS.pak" ]; then
    ./OpenBOR_mod "$ROM_FILE"
else
    ./OpenBOR_new "$ROM_FILE"
fi
sync