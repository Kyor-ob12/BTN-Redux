#!/bin/sh

# Default BTNresources values for NDS 
EMU_CORES=${EMU_CORES:-4}
EMU_CPU=${EMU_CPU:-1200}
GPU_MHZ=${GPU_MHZ:-384}

cpuclock performance $EMU_CORES $EMU_CPU $GPU_MHZ
echo $0 $*
progdir="/mnt/SDCARD/Emu/NDS"
cd $progdir

if [ ! -f "/tmp/.show_hotkeys" ]; then
    touch /tmp/.show_hotkeys
    LD_LIBRARY_PATH=libs2:/usr/miyoo/lib ./show_hotkeys
fi

export HOME=$progdir
export LD_LIBRARY_PATH=libs:/usr/miyoo/lib:/usr/lib
export SDL_VIDEODRIVER=mmiyoo
export SDL_AUDIODRIVER=mmiyoo
export EGL_VIDEODRIVER=mmiyoo

sv=`cat /proc/sys/vm/swappiness`
echo 10 > /proc/sys/vm/swappiness

if [ -f 'libs/libEGL.so' ]; then
    rm -rf libs/libEGL.so
    rm -rf libs/libGLESv1_CM.so
    rm -rf libs/libGLESv2.so
fi

./drastic "$1"
sync

echo $sv > /proc/sys/vm/swappiness
