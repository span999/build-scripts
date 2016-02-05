#
#!/bin/bash
# shell script for rogue/humpback/zeus platform with 4.x/5.x android 1024x600


ASDKEMULATORDIR=~/workshop/bin/Android/android-sdk-linux_x86
ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
#ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/skins

if [ $2 = "zeus" ]; then
	ACUSTSKIN=WVGA800zeus
fi
if [ $2 = "humpback" ]; then
	ACUSTSKIN=WVGA800humpback
fi
if [ $2 = "rogue" ]; then
	ACUSTSKIN=Daiwoo-1024x600
fi

#ASDKSKINDIR=${ASDKEMULATORDIR}/../mitac-sdk/cust-image/skins/${ACUSTSKIN}
ASDKSKINDIR=${ASDKEMULATORDIR}/../mitac-sdk/cust-image/skins


AAVD=Daiwoo-1024x600_4.4.2_8.0inch-cust
#AAVD=Daiwoo-1024x600_4.4.2_8.0inch
#AAVD=Daiwoo-1024x600_5.0.0_7.0inch-cust
if [ $1 = "r4.4.3" ]; then
	AAVD=Daiwoo-1024x600_4.4.2_8.0inch-cust
	ASDKSYSDIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/android-sdk-4.4.2_armeabi-v7a/4.4.3_r1
	ASDKDATADIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/android-sdk-4.4.2_armeabi-v7a/4.4.3_r1
fi
if [ $1 = "r4.4.4" ]; then
	AAVD=Daiwoo-1024x600_4.4.4_8.0inch-cust
	ASDKSYSDIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/android-sdk-4.4.2_armeabi-v7a/4.4.4_r2
	ASDKDATADIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/android-sdk-4.4.2_armeabi-v7a/4.4.4_r2
fi
if [ $1 = "r5.0" ]; then
	AAVD=Daiwoo-1024x600_5.0.0_7.0inch-cust
	ASDKSYSDIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/android-sdk-4.4.2_armeabi-v7a/5.0.2_r1
	ASDKDATADIR=$ASDKEMULATORDIR/../mitac-sdk/cust-image/android-sdk-4.4.2_armeabi-v7a/5.0.2_r1
fi
if [ $1 = "4.4.4" ]; then
	AAVD=Daiwoo-1024x600_4.4.2_8.0inch
	ASDKSYSDIR=$ASDKEMULATORDIR/system-images/android-19/default/armeabi-v7a
	ASDKDATADIR=$ASDKEMULATORDIR/system-images/android-19/default/armeabi-v7a
fi
if [ $1 = "5.0" ]; then
	AAVD=Daiwoo-1024x600_5.0.0_7.0inch
	ASDKSYSDIR=$ASDKEMULATORDIR/system-images/android-21/default/armeabi-v7a
	ASDKDATADIR=$ASDKEMULATORDIR/system-images/android-21/default/armeabi-v7a
fi


echo "**********************************************"
echo "project=$1 skin=$2"
echo "avd=${AAVD}"
echo "sysdir=${ASDKSYSDIR}"
echo "skin=${ACUSTSKIN}"
echo "skin path=${ASDKSKINDIR}"
echo "**********************************************"

# sysdir, -datadir, -kernel, -ramdisk, -system, -data, -cache -sdcard and -snapstorage

#../../tools/emulator @ics-cust -sysdir $ASDKSYSDIR -datadir $ASDKDATADIR -skindir $ASDKSKINDIR -sdcard $ASDKSKINDIR/FakeSDcard.iso -memory 512 -dpi-device 140 -skin WVGA800zeus -show-kernel -debug all

#../../tools/emulator @ics -skindir $ASDKSKINDIR -skin WVGA800zeus -dpi-device 240 -show-kernel -debug all

#../android-sdk-linux_x86/tools/emulator @${AAVD} -skindir $ASDKSKINDIR -skin ${ACUSTSKIN} -dpi-device 240 -show-kernel -debug all

#../android-sdk-linux_x86/tools/emulator @${AAVD} -skindir ${ASDKSKINDIR} -skin ${ACUSTSKIN} -show-kernel -debug all

../android-sdk-linux_x86/tools/emulator @${AAVD} -sysdir ${ASDKSYSDIR} -datadir ${ASDKDATADIR} -memory 2048 -skindir ${ASDKSKINDIR} -skin ${ACUSTSKIN} -show-kernel -debug console -debug gps -debug adb -debug init

#../android-sdk-linux_x86/tools/emulator @${AAVD} -show-kernel -scale 0.9 -debug all
#../android-sdk-linux_x86/tools/emulator @${AAVD} -show-kernel -scale 0.9 -debug console	
