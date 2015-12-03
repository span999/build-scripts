#!/bin/sh
#

#
# http://dl.google.com/android/android-sdk_r22.0.5-linux.tgz
#

ROT_PATH=`pwd`
BIN_PATH=~/workshop/bin/android-sdk
IMG_PATH=${ROT_PATH}/out
KIMG_PATH=${ROT_PATH}/kout

TOOLS_PATH=`find ${BIN_PATH}/ -name \tools -type d -not -path *com* -not -path *docs*`
EMULATOR=`find ${BIN_PATH}/ -name \emulator -executable -type f -path *bin*`
ANDROID=`find ${BIN_PATH}/ -name \android -executable -type f -path *bin*`
RAMDISKIMG=`find ${IMG_PATH}/ -name \ramdisk.img -type f`
SYSTEMIMG=`find ${IMG_PATH}/ -name \system.img -type f -not -path *obj*`
USERDATAIMG=`find ${IMG_PATH}/ -name \userdata.img -type f`
KERNELIMG=`find ${KIMG_PATH}/ -name \zImage -type f`

echo "tools path=${TOOLS_PATH}"
echo "emulator=${EMULATOR}"
echo "android=${ANDROID}"
echo "ramdisk.img=${RAMDISKIMG}"
echo "system.img=${SYSTEMIMG}"
echo "userdata.img=${USERDATAIMG}"
echo "zImage=${KERNELIMG}"

echo "you have download tools & API within android device manager ..."
#cd ${TOOLS_PATH}
#echo current path=`pwd`
#./android
#cd ${ROT_PATH}

echo "create AVD on android GUI or CLI ... "
cd ${TOOLS_PATH}
echo current path=`pwd`
./android - list avd
cd ${ROT_PATH}

cd ${TOOLS_PATH}
echo current path=`pwd`
./emulator -avd AVD_for_my_Nexus_7 -system ${SYSTEMIMG} -ramdisk ${RAMDISKIMG} -data ${USERDATAIMG} -kernel ${KERNELIMG}
cd ${ROT_PATH}

