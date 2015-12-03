#!/bin/sh
#

#
#
#

txtrst=$(tput sgr0) # Text reset.
bgred=$(tput setab 1) # Red


ROT_PATH=`pwd`
SRC_BASE=/home/span/workshop/git/android/android-4.3_r2
CCACHE_PATH=prebuilts/misc/linux-x86/ccache
BLD_LINK=android-src
BLD_BASE=${ROT_PATH}/${BLD_LINK}
CCACHE_BASE=${BLD_BASE}/${CCACHE_PATH}
CCACHE_BIN=${BLD_BASE}/${CCACHE_PATH}/ccache

REL_BASE=${ROT_PATH}
OUT_PATH=${REL_BASE}/out
LOG_NAME=abuild.log
BLD_LOG=${ROT_PATH}/${LOG_NAME}

_TIMEBUILDSTART=
_TIMEBUILDEND=
_TIMEBUILD=


echo ""
echo "${bgred}   <<<about to build android iamge for emulator ...>>>   ${txtrst}"
echo current path=`pwd`

echo ""
echo "${bgred}   <<<setup ccatch ...>>>   ${txtrst}"
if [ -L ${BLD_LINK} ]; then
	rm -rf ${BLD_LINK}
fi
ln -s ${SRC_BASE} ${BLD_LINK}

if [ -f ${CCACHE_BIN} ]; then
	echo ""
	echo "${bgred}   <<<setup ccatch -M 10G ...>>>   ${txtrst}"
	export USE_CCACHE=1
	${CCACHE_BIN} -M 10G
fi

echo ""
echo "${bgred}   <<<create output folder ...>>>   ${txtrst}"
if [ -d ${OUT_PATH} ]; then 
	echo ""
	echo "remove old out folder ..."
	rm -rf ${OUT_PATH}
fi
mkdir -p ${OUT_PATH}
echo ""
echo "${bgred}   <<<set output to ${OUT_PATH} ...>>>   ${txtrst}"
export OUT_DIR_COMMON_BASE=${OUT_PATH}

cd ${BLD_LINK}
echo current path=`pwd`
echo ""
echo "${bgred}   <<<setup build env ...>>>   ${txtrst}"
. build/envsetup.sh

echo ""
echo "${bgred}   <<<setup emulator build with development configuration ...>>>   ${txtrst}"
lunch full-eng

if [ -f ${BLD_LOG} ]; then 
	echo ""
	echo "${bgred}   <<<remove old log file ...>>>   ${txtrst}"
	rm -rf ${BLD_LOG}
fi

echo ""
echo "${bgred}   <<<start source build ...>>>   ${txtrst}"
_TIMEBUILDSTART=$(date +"%s")
make -j4 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
echo "${bgred}   <<<end source build ...>>>   ${txtrst}"

cd ${ROT_PATH}
echo current path=`pwd`
echo ""
echo "${bgred}   <<<build time=${_TIMEBUILD} seconds.>>>   ${txtrst}"


