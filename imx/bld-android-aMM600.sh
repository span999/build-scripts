#!/bin/sh
#

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red

NOWTIME=`date +%Y%m%d%02k%02M%02S`
AROOT=`pwd`
WSFOLDER=anadroid-emulator
WSPATH=${AROOT}/${WSFOLDER}
CPUS=12
AVER=6.0.0_r1
#AVER=5.0.2_r1
#AVER=4.4.3_r1

AFOLDER=android-${AVER}
BUBOARD=aosp_arm
BUMODE=eng
LUNCHTYPE=${BUBOARD}-${BUMODE}
#LUNCHTYPE=aosp_arm-eng
CCACHE_BIN=

TARPATH=/home/span/workshop/git/android/tarball
SRCTAR=android-${AVER}_src.tar.xz

if [ ! -d ${WSFOLDER} ]; then
	mkdir -p ${WSPATH}
fi
cd ${WSPATH}
echo `pwd`


if [ "${AVER}" = "4.4.3_r1" ]; then
#export JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
export JAVA_HOME=/home/span/workshop/bin/jdk1.6.0_45
export PATH=/home/span/workshop/bin/jdk1.6.0_45/bin:$PATH
fi

echo "${_Br}#"
echo "# <<<JAVA_HOME=${JAVA_HOME}>>> "
echo "#${_Tr}"

echo "${_Br}#"
echo "**************************************************"
echo "ROOT=${AROOT}"
echo "AFOLDER=${AFOLDER}"
echo "AVER=${AVER}"
echo "LUNCHTYPE=${LUNCHTYPE}"
echo "**************************************************"
echo "#${_Tr}"

_TIMEDOWNLOAD=0
if [ ! -d ${AVER}_src ]; then
	rm ${AFOLDER}
	mkdir ${AVER}_src
	_TIMEBUILDSTART=$(date +"%s")
	tar xvf ${TARPATH}/${SRCTAR} -C ${AVER}_src/
	ln -s ${AVER}_src/myandroid ${AFOLDER}
	_TIMEBUILDEND=$(date +"%s")
	_TIMEDOWNLOAD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
fi
if [ "${AVER}" = "5.0.2_r1" ]; then
	echo "${_Br}#"
	echo "# <<<PATCH! replace commit_id.target.linux-arm.mk >>> "
	echo "#${_Tr}"
	cp -f ${TARPATH}/commit_id.target.linux-arm.mk ${AFOLDER}/external/chromium_org/third_party/angle/src/commit_id.target.linux-arm.mk
fi

cd ${AFOLDER}
echo `pwd`


export USE_CCACHE=1
#export CCACHE_DIR=~/.accache
#export CCACHE_DIR=~/.ccache
CCACHE_BIN=`find ./ -type f -path "*linux-x86*" -name \ccache`
${CCACHE_BIN} -M 25G
. build/envsetup.sh
lunch ${LUNCHTYPE}

make clean

touch startTIME
_TIMEBUILDSTART=$(date +"%s")
#make -j8 2>&1 | tee ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
make -j${CPUS} 2>&1 | tee ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
touch endTIME
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

cd ${AROOT}
echo `pwd`
echo "${_Br}#"
echo "# download time=${_TIMEDOWNLOAD} seconds."
echo "# build    time=${_TIMEBUILD} seconds."
#echo "# mkubi    time=${_TIMEMKUBI} seconds."
echo "#${_Tr}"

# _E_O_F_
