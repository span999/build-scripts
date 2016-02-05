#
#!/bin/bash
# shell script for humpback platform with 2.3 android WVGA


ASDKEMULATORDIR=~/workshop/bin/android-sdk-linux_x86
ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-2.2-noPhone/images
ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-2.2-noPhone/images
ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/skins

../../tools/emulator -sysdir $ASDKSYSDIR -datadir $ASDKDATADIR -skindir $ASDKSKINDIR -sdcard $ASDKSKINDIR/FakeSDcard512.iso -memory 256 -dpi-device 160 -skin WVGA800zeus -show-kernel -debug all


