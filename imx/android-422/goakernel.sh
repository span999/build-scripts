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



cd ${ROOT_PATH}
A_WKSP=~/workshop/svn/checkout/n425/linux/linux-3.0
A_SVN=https://n425.cee.mitac.com/svn/n425
A_REPO=${A_SVN}/branches/user/span/timesys/linux-src/linux-3.0_rudolf_android422-110
svn sw ${A_REPO} ${A_WKSP}
svn up ${A_WKSP}
rm -rf kernel-rudolf
svn export ${A_WKSP} kernel-rudolf

if [ ! -L kernel_imx ]; then
	if [ -d kernel_imx ]; then
		mv kernel_imx kernel_imx_org
	fi
	echo "#"
	echo "# create link ... "
	echo "#"
	ln -s kernel-rudolf kernel_imx
fi

cd ${ROOT_PATH}
echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# start linux kernel build ..."
echo "#"

cd kernel_imx
#cd kernel-rudolf
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
echo "# kerenl 		build time=${_TIMEBUILDUKERNEL} seconds."
echo "#"

