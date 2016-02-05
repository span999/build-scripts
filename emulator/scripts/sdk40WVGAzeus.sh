#
#!/bin/bash
# shell script for humpback platform with 4.0 android WVGA


ASDKEMULATORDIR=~/workshop/bin/android-sdk-linux_x86
ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/skins

#../../tools/emulator @ics-cust -sysdir $ASDKSYSDIR -datadir $ASDKDATADIR -skindir #$ASDKSKINDIR -sdcard $ASDKSKINDIR/FakeSDcard.iso -memory 512 -dpi-device 140 -#skin WVGA800zeus -show-kernel -debug all

../../tools/emulator @ics-cust -show-kernel -debug all
