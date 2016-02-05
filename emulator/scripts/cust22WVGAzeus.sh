#
#!/bin/bash
# shell script for humpback platform with 2.2 android WVGA


ASDKEMULATORDIR=~/workshop/bin/android-sdk-linux_x86
ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/zeus/2.2/R11.3.8900.0721_Generic
ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/zeus/2.2/R11.3.8900.0721_Generic
ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/skins

../../tools/emulator -sysdir $ASDKSYSDIR -datadir $ASDKDATADIR -skindir $ASDKSKINDIR -sdcard $ASDKSKINDIR/FakeSDcard.iso -memory 256 -dpi-device 140 -skin WVGA800zeus -show-kernel -debug all


