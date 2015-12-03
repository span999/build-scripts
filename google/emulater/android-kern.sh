#!/bin/sh
#

#
# git clone https://android.googlesource.com/kernel/goldfish.git
#

txtrst=$(tput sgr0) # Text reset.
bgred=$(tput setab 1) # Red


ROT_PATH=`pwd`
SRC_BASE=/home/span/workshop/git/android/goldfish/goldfish
BLD_LINK=goldfish-src
BLD_BASE=${ROT_PATH}/${BLD_LINK}

ANDROID_BASE=/home/span/workshop/git/android/android-4.3_r2
CC_PATH=prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin
ANDROID_LINK=android-src
CC_PREFIX=${ANDROID_BASE}/${CC_PATH}/arm-eabi-

REL_BASE=${ROT_PATH}
OUT_PATH=${REL_BASE}/kout
LOG_NAME=kbuild.log
BLD_LOG=${ROT_PATH}/${LOG_NAME}

_TIMEBUILDSTART=
_TIMEBUILDEND=
_TIMEBUILD=


echo ""
echo "${bgred}   <<<going to build goldfish kernel image ...>>>   ${txtrst}"

echo current path=`pwd`

echo ""
echo "${bgred}   <<<create android link ...>>>   ${txtrst}"
if [ -L ${ANDROID_LINK} ]; then
	rm -rf ${ANDROID_LINK}
fi
ln -s ${ANDROID_BASE} ${ANDROID_LINK}

echo ""
echo "${bgred}   <<<create source link ...>>>   ${txtrst}"
if [ -L ${BLD_LINK} ]; then
	rm -rf ${BLD_LINK}
fi
ln -s ${SRC_BASE} ${BLD_LINK}

echo ""
echo "${bgred}   <<<create output folder ...>>>   ${txtrst}"
if [ -d ${OUT_PATH} ]; then 
	echo ""
	echo "${bgred}   <<<remove old out folder ...>>>   ${txtrst}"
	rm -rf ${OUT_PATH}
fi
mkdir -p ${OUT_PATH}
echo ""
echo "${bgred}   <<<set output to ${OUT_PATH} ...>>>   ${txtrst}"
export KBUILD_OUTPUT=${OUT_PATH}

if [ -f ${BLD_LOG} ]; then 
	echo ""
	echo "${bgred}   <<<remove old log file ...>>>   ${txtrst}"
	rm -rf ${BLD_LOG}
fi


cd ${BLD_LINK}
echo current path=`pwd`

echo ""
echo "${bgred}   <<<checkout goldfish source ...>>>   ${txtrst}"
git branch -a
git checkout -t origin/android-goldfish-2.6.29 -b goldfish

##export PATH=<ANDROID BASEDIR>/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin:$PATH
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=${CC_PREFIX}


echo ""
echo "${bgred}   <<<defconfig goldfish_armv7_defconfig ...>>>   ${txtrst}"
make goldfish_armv7_defconfig

echo ""
echo "${bgred}   <<<start kernel source build ...>>>   ${txtrst}"
_TIMEBUILDSTART=$(date +"%s")
make -j8 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
echo "${bgred}   <<<end kernel source build ...>>>   ${txtrst}"


cd ${ROT_PATH}
echo current path=`pwd`
echo ""
echo "${bgred}   <<<build time=${_TIMEBUILD} seconds.>>>   ${txtrst}"


