#
#!/bin/bash
# shell script for humpback platform with 4.0 android WVGA

#_VER_=2.3
#_VER_=2.3-noPhone
#_VER_=4.0
#_VER_=4.4.2sdk
_VER_=5.0sdk

AAVD=Daiwoo-1024x600_4.4.2_8.0inch-cust
#AAVD=Daiwoo-1024x600_7inch_API19

_SKIN_=HUMPBACK
#_SKIN_=ZEUS

ASDKEMULATORDIR=~/workshop/bin/android-sdk-linux_x86
ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/skins
#ASDKSDCARDIMG=FakeSDcard.iso
ASDKSDCARDIMG=FakeSDcard512.iso
#ASDKRAM=512
ASDKRAM=1024

if [ "${_VER_}" = "2.3" ]; then
	ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-2.3/images
	ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-2.3/images
fi
if [ "${_VER_}" = "2.3-noPhone" ]; then
	ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-2.3-noPhone/images
	ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-2.3-noPhone/images
fi
if [ "${_VER_}" = "4.0" ]; then
	ASDKSYSDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
	ASDKDATADIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/android-sdk-4.0/images
fi
if [ "${_VER_}" = "4.2.2sdk" ]; then
	ASDKSYSDIR=$ASDKEMULATORDIR/system-images/android-19/default/armeabi-v7a
	ASDKDATADIR=$ASDKEMULATORDIR/system-images/android-19/default/armeabi-v7a
fi
if [ "${_VER_}" = "5.0sdk" ]; then
	ASDKSYSDIR=$ASDKEMULATORDIR/system-images/android-21/default/armeabi-v7a
	ASDKDATADIR=$ASDKEMULATORDIR/system-images/android-21/default/armeabi-v7a
fi

if [ "${_SKIN_}" = "HUMPBACK" ]; then
	ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/skins
	ASDKSKINNAME=WVGA800humpback
fi
if [ "${_SKIN_}" = "ZEUS" ]; then
	ASDKSKINDIR=$ASDKEMULATORDIR/platforms/mitac/cust-image/skins
	ASDKSKINNAME=WVGA800zeus
fi

#../../tools/emulator @ics-cust -sysdir $ASDKSYSDIR -datadir $ASDKDATADIR -skindir #$ASDKSKINDIR -sdcard $ASDKSKINDIR/FakeSDcard.iso -memory 512 -dpi-device 140 -#skin WVGA800zeus -show-kernel -debug all

#../../tools/emulator -sysdir ${ASDKSYSDIR} -datadir ${ASDKDATADIR} -skindir ${ASDKSKINDIR} -data ${ASDKDATADIR}/userdata.img -skin ${ASDKSKINNAME} -sdcard ${ASDKSKINDIR}/FakeSDcard.iso -memory ${ASDKRAM} -dpi-device 140 -show-kernel -debug all
#../../tools/emulator -sysdir ${ASDKSYSDIR} -datadir ${ASDKDATADIR} -skindir ${ASDKSKINDIR} -skin ${ASDKSKINNAME} -sdcard ${ASDKSKINDIR}/${ASDKSDCARDIMG} -memory ${ASDKRAM} -dpi-device 140 -show-kernel -debug all

../android-sdk-linux_x86/tools/emulator @${AAVD} -show-kernel -debug all

#../../tools/emulator @ics-cust -skindir $ASDKSKINDIR -skin WVGA800humpback -dpi-device 240 -show-kernel -debug all

