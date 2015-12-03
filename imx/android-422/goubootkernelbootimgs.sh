#!/bin/sh
#

#
#
#


ROOT_PATH=`pwd`
SCRIPT_PATH=${ROOT_PATH}/../script
#CCACHE_BIN=${ROOT_PATH}/prebuilts/misc/linux-x86/ccache/ccache
CCACHE_BIN=/usr/bin/ccache
OUT_PATH=${ROOT_PATH}/out
LOG_NAME=build.log
BLD_LOG=${ROOT_PATH}/${LOG_NAME}

myARCH=arm
#myCC=${ROOT_PATH}/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-
myCC=${ROOT_PATH}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
mySET="ARCH=${myARCH} CROSS_COMPILE=${myCC}"

echo "#"
echo "# current path=${ROOT_PATH}"
echo "#"
echo "# Cross compile env=>"
echo "# ${mySET}"
echo "#"

CCACHE_BIN=`find prebuilts/ -name ccache -path "*linux-x86*" -type f`
if [ ${CCACHE_BIN} == "" ]; then
	CCACHE_BIN=/usr/bin/ccache
fi
if [ -f ${CCACHE_BIN} ]; then
	echo "#"
	echo "# ccache=${CCACHE_BIN}"
	echo "# setup ccache -M 10G ..."
	echo "#"
	export USE_CCACHE=1
	${CCACHE_BIN} -M 10G
fi

if [ -d ${OUT_PATH} ]; then 
	echo "#"
	echo "# remove old out folder ..."
	echo "#"
	rm -rf ${OUT_PATH}
fi
mkdir -p ${OUT_PATH}
echo "#"
echo "# set output to ${OUT_PATH} ..."
echo "#"
export OUT_DIR_COMMON_BASE=${OUT_PATH}



echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# start u-boot build ..."
echo "#"

cd bootable/bootloader/uboot-imx
echo "#"
echo "# current path=`pwd`"
echo "#"

make distclean ${mySET}
make mx6q_sabresd_android_config ${mySET}

BLD_LOG=${ROOT_PATH}/uboot-${LOG_NAME}
if [ -e ${BLD_LOG} ]; then
	rm -rf ${BLD_LOG}
fi 
_TIMEBUILDSTART=$(date +"%s")
make -j4 ${mySET} 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
_TIMEBUILDUBOOT=${_TIMEBUILD}


cd ${ROOT_PATH}
echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# start linux kernel build ..."
echo "#"

cd kernel_imx
echo "#"
echo "# current path=`pwd`"
echo "#"

echo "# linux override kernel Makefile !!"
sed -i 's/-ts-armv7l/_MBU/g' Makefile

make distclean ${mySET}
make mrproper ${mySET}
#make imx6_android_defconfig ${mySET}
make imx6_neverlost6_android_defconfig ${mySET}

BLD_LOG=${ROOT_PATH}/linux-${LOG_NAME}
if [ -e ${BLD_LOG} ]; then
	rm -rf ${BLD_LOG}
fi 
_TIMEBUILDSTART=$(date +"%s")
make -j4 uImage ${mySET} 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
_TIMEBUILDUKERNEL=${_TIMEBUILD}


cd ${ROOT_PATH}
echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# start android boot.img build ..."
echo "#"

echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# setup build env ..."
echo "#"
. build/envsetup.sh

echo "#"
echo "# setup sabresd build with development configuration ..."
echo "#"
#lunch sabresd_6dq-user
lunch sabresd_6dq-eng

BLD_LOG=${ROOT_PATH}/boot-${LOG_NAME}
if [ -e ${BLD_LOG} ]; then
	rm -rf ${BLD_LOG}
fi 
_TIMEBUILDSTART=$(date +"%s")
make -j4 bootimage ${mySET} 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
_TIMEBUILDUBOOT=${_TIMEBUILD}


cd ${ROOT_PATH}
echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# u-boot 		build time=${_TIMEBUILDUBOOT} seconds."
echo "# kerenl 		build time=${_TIMEBUILDUKERNEL} seconds."
echo "# boot.img	build time=${_TIMEBUILDUBOOT} seconds."
echo "#"

