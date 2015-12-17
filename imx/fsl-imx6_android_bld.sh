#!/bin/sh
#
# sudo update-alternatives --config java (choose as needed)
# sudo update-alternatives --config javac (choose as needed)
# sudo apt-get install uuid-dev (L5 no need)
# sudo apt-get install liblzo2-dev (L5 no need)
#

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red

NOWTIME=`date +%y%m%d-%02k%02M%02S`
AROOT=`pwd`
CPUS=12

#AVER=5.0.2_r1
AVER=4.4.3_r1
#AVER=4.2.2_r1


USERIN=$1
USERP1=$2

if [ "${USERIN}" = "" ]; then
	echo "no user input !! try <443> or <422> or <502> or <rogue>"
	exit
fi

if [ "${USERIN}" = "443" -o "${USERIN}" = "422" -o "${USERIN}" = "502" -o "${USERIN}" = "rogue" ]; then
	echo "  user input =<${USERIN}> para1 =<${USERP1}>"
	if [ "${USERIN}" = "443" -o "${USERIN}" = "rogue" ]; then
		AVER=4.4.3_r1
	fi
	if [ "${USERIN}" = "422" ]; then
		AVER=4.2.2_r1
	fi
	if [ "${USERIN}" = "502" ]; then
		AVER=5.0.2_r1
	fi
else
	echo "wrong user input !! try <443> or <422> or <502> or <rogue>"
	exit
fi


if [ "${USERIN}" = "rogue" ]; then
	WSFOLDER=rogue-fsl
else
	WSFOLDER=anadroid-fsl
fi
WSPATH=${AROOT}/${WSFOLDER}
OUT_DIR=${AROOT}/${WSFOLDER}/out
AFOLDER=android-${AVER}
#BUBOARD=aosp_arm-eng  #for original android build
BUBOARD=sabresd_6dq
#BUMODE=user
BUMODE=eng
LUNCHTYPE=${BUBOARD}-${BUMODE}
BUPARAM=

if [ "${AVER}" = "5.0.2_r1" ]; then
	BUBOARD=sabresd_6dq
	#BUMODE=user
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
	BUPARAM="BUILD_TARGET_DEVICE=sd"
fi
if [ "${AVER}" = "4.4.3_r1" ]; then
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi
if [ "${USERIN}" = "rogue" ]; then
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi
if [ "${AVER}" = "4.2.2_r1" ]; then
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi


###java -version > ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
###JAVAVER=`java -version`
JAVAVER=$("java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
which java
###uname -a >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
SYSTEMNAME=`uname -a`

echo "**************************************************"
echo "JAVA version=${JAVAVER}"
echo "System name=${SYSTEMNAME}"
echo "ROOT=${AROOT}"
echo "AFOLDER=${AFOLDER}"
echo "OUT_DIR=${OUT_DIR}"
echo "AVER=${AVER}"
echo "LUNCHTYPE=${LUNCHTYPE}"
echo "**************************************************"

cd ${WSPATH}
cd ${AFOLDER}
echo `pwd`

export USE_CCACHE=1
#export CCACHE_DIR=~/.ccache
#prebuilts/misc/linux-x86/ccache/ccache -M 25G
CCACHE_BIN=`find ./ -type f -path "*linux-x86*" -name \ccache`
${CCACHE_BIN} -M 25G
export OUT_DIR_COMMON_BASE=${OUT_DIR}
LOGFILE=${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt

. build/envsetup.sh
lunch ${LUNCHTYPE}

echo "**************************************************" >> ${LOGFILE}
echo "JAVA version=${JAVAVER}" >> ${LOGFILE}
echo "System name=${SYSTEMNAME}" >> ${LOGFILE}
echo "ROOT=${AROOT}" >> ${LOGFILE}
echo "AFOLDER=${AFOLDER}" >> ${LOGFILE}
echo "OUT_DIR=${OUT_DIR}" >> ${LOGFILE}
echo "AVER=${AVER}" >> ${LOGFILE}
echo "LUNCHTYPE=${LUNCHTYPE}" >> ${LOGFILE}
echo "**************************************************" >> ${LOGFILE}

OUTTARGETBOARD=${OUT_DIR}/${AFOLDER}/target/product/${BUBOARD}
if [ "fast" = "${USERP1}" ]; then
	echo "NOT doing clean on out..." >> ${LOGFILE}
	rm -rf ${OUTTARGETBOARD}/*.img
	rm -rf ${OUTTARGETBOARD}/u-boot*.*
else
	echo "GO doing clean on out..." >> ${LOGFILE}
	make clean
fi


touch startTIME
_TIMEBUILDSTART=$(date +"%s")
make -j${CPUS} ${BUPARAM} 2>&1 | tee -a ${LOGFILE}
touch endTIME
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

echo "" >> ${LOGFILE}
echo "# build    time=${_TIMEBUILD} seconds." >> ${LOGFILE}
echo "" >> ${LOGFILE}




if [ "${AVER}" = "4.4.3_r1" ]; then
	SDLOGFILE=${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]sd-log.txt
	touch startTIMEsd
	mkdir -p ${OUTTARGETBOARD}/NAND
	mv ${OUTTARGETBOARD}/boot*.img ${OUTTARGETBOARD}/NAND
	mv ${OUTTARGETBOARD}/recovery*.img ${OUTTARGETBOARD}/NAND
	rm -rf ${OUTTARGETBOARD}/root
	rm -rf ${OUTTARGETBOARD}/boot*.img
	rm -rf ${OUTTARGETBOARD}/recovery
	rm -rf ${OUTTARGETBOARD}/recovery*.img
	
	echo "**************************************************" >> ${SDLOGFILE}
	echo "JAVA version=${JAVAVER}" >> ${SDLOGFILE}
	echo "System name=${SYSTEMNAME}" >> ${SDLOGFILE}
	echo "ROOT=${AROOT}" >> ${SDLOGFILE}
	echo "AFOLDER=${AFOLDER}" >> ${SDLOGFILE}
	echo "OUT_DIR=${OUT_DIR}" >> ${SDLOGFILE}
	echo "AVER=${AVER}" >> ${SDLOGFILE}
	echo "LUNCHTYPE=${LUNCHTYPE}" >> ${SDLOGFILE}
	echo "bootimage BUILD_TARGET_DEVICE=sd" >> ${SDLOGFILE}
	echo "**************************************************" >> ${SDLOGFILE}
	
	_TIMEBUILDSTARTSD=$(date +"%s")
	make -j${CPUS} bootimage BUILD_TARGET_DEVICE=sd 2>&1 | tee -a ${SDLOGFILE}
	_TIMEBUILDENDSD=$(date +"%s")
	_TIMEBUILDSD=$(($_TIMEBUILDENDSD-$_TIMEBUILDSTARTSD))
	touch endTIMEsd

	mkdir -p ${OUTTARGETBOARD}/SDMMC
	cp ${OUTTARGETBOARD}/boot*.img ${OUTTARGETBOARD}/SDMMC
	cp ${OUTTARGETBOARD}/recovery*.img ${OUTTARGETBOARD}/SDMMC

	echo "" >> ${SDLOGFILE}
	echo "# build    time=${_TIMEBUILDSD} seconds." >> ${SDLOGFILE}
	echo "" >> ${SDLOGFILE}

fi

cd ${AROOT}
echo `pwd`
echo "${_Br}#"
#echo "# download time=${_TIMEDOWNLOAD} seconds."
echo "# build    time=${_TIMEBUILD} seconds."
#echo "# mkubi    time=${_TIMEMKUBI} seconds."
echo "#${_Tr}"


# _E_O_F_
