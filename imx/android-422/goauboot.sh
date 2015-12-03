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
A_WKSP=/home/span/workshop/svn/checkout/n425/uboot/L3.0.35_1209
A_SVN=https://n425.cee.mitac.com/svn/n425
A_REPO=${A_SVN}/branches/user/span/uboot/rudolf/u-boot_1209_ruldolf_SSD_Android
svn sw ${A_REPO} ${A_WKSP}
svn up ${A_WKSP}
cd bootable/bootloader
rm -rf uboot-rudolf
svn export ${A_WKSP} uboot-rudolf
LREV=`svn info ${A_WKSP} | grep "Last Changed Rev:" | cut -d ' ' -f 4`
echo "sdA_r${LREV}" > uboot-rudolf/localversion

if [ ! -L uboot-imx ]; then
	if [ -d uboot-imx ]; then
		mv uboot-imx uboot-imx_org
	fi
	echo "#"
	echo "# create link ... "
	echo "#"
	ln -s uboot-rudolf uboot-imx
fi

cd ${ROOT_PATH}
echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# start u-boot build ..."
echo "#"

cd bootable/bootloader/uboot-imx
#cd bootable/bootloader/uboot-rudolf
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
echo "# u-boot 		build time=${_TIMEBUILDUBOOT} seconds."
echo "#"

