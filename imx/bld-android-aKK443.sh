#!/bin/sh
#
#

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red

NOWTIME=`date +%Y%m%d%02k%02M%02S`
AROOT=`pwd`
WSFOLDER=anadroid-emulator
WSPATH=${AROOT}/${WSFOLDER}
CPUS=12
#AVER=5.0.2_r1
AVER=4.4.3_r1
#AVER=4.4.4_r2
#AVER=4.4.2_r2.0.1


USERIN=$1
USERP1=$2

if [ "${USERIN}" = "" ]; then
	echo "no user input !! try <google> or <rogue>"
	exit
fi

if [ "${USERIN}" = "google" -o "${USERIN}" = "rogue" ]; then
	echo "  user input =<${USERIN}> para1 =<${USERP1}>"
	if [ "${USERIN}" = "google" -o "${USERIN}" = "rogue" ]; then
		AVER=4.4.3_r1
		#AVER=4.4.2_r2.0.1
		#AVER=4.4.4_r2
	fi
	if [ "${USERIN}" = "rogue" ]; then
		AVER=4.4.3_r1
	fi
else
	echo "wrong user input !! try <google> or <rogue>"
	exit
fi


AFOLDER=android-${AVER}
if [ "${USERIN}" = "rogue" ]; then
	AFOLDER=rogue-${AVER}
fi
BUBOARD=aosp_arm
BUMODE=eng
LUNCHTYPE=${BUBOARD}-${BUMODE}
#LUNCHTYPE=aosp_arm-eng
CCACHE_BIN=
OUT_DIR=${AROOT}/${WSFOLDER}/${AFOLDER}_out

TARPATH=/home/span/workshop/git/android/tarball
SRCTAR=android-${AVER}_src.tar.xz

if [ ! -d ${WSFOLDER} ]; then
	mkdir -p ${WSPATH}
fi
cd ${WSPATH}
echo `pwd`


if [ "${AVER}" = "4.4.3_r1" -o "${AVER}" = "4.4.4_r2" -o "${AVER}" = "4.4.2_r2.0.1" ]; then
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
echo "OUT_DIR=${OUT_DIR}"
echo "**************************************************"
echo "#${_Tr}"

_TIMEDOWNLOAD=0
if [ "${USERIN}" = "rogue" ]; then
	# create android source link
	rm ${AFOLDER}
	ln -s ~/workshop/build/android/rogue-fsl/android-${AVER} ${AFOLDER}
	cd ${AFOLDER}
	# check out aosp source
	git checkout N535-Rogue-EMU_span
	# create android out link
	rm out
	ln -s ${AROOT}/${WSFOLDER}/${AFOLDER}_out/${AFOLDER} out
	cd -
fi

if [ "${USERIN}" = "google" ]; then
	if [ ! -d ${AVER}_src ]; then
		rm ${AFOLDER}
		mkdir ${AVER}_src
		_TIMEBUILDSTART=$(date +"%s")
		tar xvf ${TARPATH}/${SRCTAR} -C ${AVER}_src/
		if [ "${AVER}" = "4.4.3_r1" ]; then
			ln -s ${AVER}_src/myandroid ${AFOLDER}
		fi
		if [ "${AVER}" = "4.4.4_r2" ]; then
			ln -s ${AVER}_src/android-${AVER} ${AFOLDER}
		fi
		_TIMEBUILDEND=$(date +"%s")
		_TIMEDOWNLOAD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
	fi
	if [ "${AVER}" = "5.0.2_r1" ]; then
		echo "${_Br}#"
		echo "# <<<PATCH! replace commit_id.target.linux-arm.mk >>> "
		echo "#${_Tr}"
		cp -f ${TARPATH}/commit_id.target.linux-arm.mk ${AFOLDER}/external/chromium_org/third_party/angle/src/commit_id.target.linux-arm.mk
	fi
fi

cd ${AFOLDER}
echo `pwd`


export USE_CCACHE=1
#export CCACHE_DIR=~/.accache
#export CCACHE_DIR=~/.ccache
CCACHE_BIN=`find ./ -type f -path "*linux-x86*" -name \ccache`
${CCACHE_BIN} -M 25G

export OUT_DIR_COMMON_BASE=${OUT_DIR}
LOGFILE=${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt

echo "**************************************************" > ${LOGFILE}
echo "ROOT=${AROOT}" >> ${LOGFILE}
echo "AFOLDER=${AFOLDER}" >> ${LOGFILE}
echo "AVER=${AVER}" >> ${LOGFILE}
echo "LUNCHTYPE=${LUNCHTYPE}" >> ${LOGFILE}
echo "OUT_DIR=${OUT_DIR}" >> ${LOGFILE}
echo "**************************************************" >> ${LOGFILE}


. build/envsetup.sh 2>&1 | tee -a ${LOGFILE}
lunch ${LUNCHTYPE} 2>&1 | tee -a ${LOGFILE}

if [ "fast" = "${USERP1}" ]; then
	echo "fast build, NOT doing clean on out..." >> ${LOGFILE}
	echo "" >> ${LOGFILE}
else
	make clean
fi


touch startTIME
_TIMEBUILDSTART=$(date +"%s")
make -j${CPUS} 2>&1 | tee -a ${LOGFILE}
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
