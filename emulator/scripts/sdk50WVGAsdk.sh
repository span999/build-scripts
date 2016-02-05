#
#!/bin/bash
# shell script for humpback platform with 4.0 android WVGA


ASDKEMULATORDIR=~/workshop/bin/android-sdk-linux_x86
ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
#ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/skins

#ACUSTSKIN=WVGA800zeus
#ACUSTSKIN=WVGA800humpback
ACUSTSKIN=Daiwoo-1024x600
ASDKSKINDIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/skins/${ACUSTSKIN}

#AAVD=Daiwoo-1024x600_4.4.2_8.0inch-cust
AAVD=Daiwoo-1024x600_5.0.0_7.0inch-cust

#../../tools/emulator @ics-cust -sysdir $ASDKSYSDIR -datadir $ASDKDATADIR -skindir $ASDKSKINDIR -sdcard $ASDKSKINDIR/FakeSDcard.iso -memory 512 -dpi-device 140 -skin WVGA800zeus -show-kernel -debug all

#../../tools/emulator @ics -skindir $ASDKSKINDIR -skin WVGA800zeus -dpi-device 240 -show-kernel -debug all

#../android-sdk-linux_x86/tools/emulator @${AAVD} -skindir $ASDKSKINDIR -skin ${ACUSTSKIN} -dpi-device 240 -show-kernel -debug all

#../android-sdk-linux_x86/tools/emulator @${AAVD} -skindir $ASDKSKINDIR -skin ${ACUSTSKIN} -show-kernel -debug all

../android-sdk-linux_x86/tools/emulator @${AAVD} -show-kernel -scale 0.9 -debug all
