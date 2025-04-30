#!/bin/sh

# Default BTNresources values for PSP 
EMU_CORES=${EMU_CORES:-4}
EMU_CPU=${EMU_CPU:-1200}
GPU_MHZ=${GPU_MHZ:-384}

cpuclock performance $EMU_CORES $EMU_CPU $GPU_MHZ
echo $0 $*
progdir="/mnt/SDCARD/Emu/PPSSPP"
cd $progdir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

echo "=============================================="
echo "==================== PPSSPP  ================="
echo "=============================================="

export HOME=/mnt/SDCARD
./miyoo282_xpad_inputd&
./PPSSPPSDL "$*"
killall miyoo282_xpad_inputd

