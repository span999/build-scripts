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

if [ "${USERIN}" = "" ]; then
	echo "no user input !! try <443> or <422> or <502>"
	exit
fi

if [ "${USERIN}" = "443" -o "${USERIN}" = "422" -o "${USERIN}" = "502" ]; then
	echo "  user input =<${USERIN}> para1 =<${USERP1}>"
	if [ "${USERIN}" = "443" ]; then
		AVER=4.4.3_r1
	fi
	if [ "${USERIN}" = "422" ]; then
		AVER=4.2.2_r1
	fi
	if [ "${USERIN}" = "502" ]; then
		AVER=5.0.2_r1
	fi
else
	echo "wrong user input !! try <443> or <422> or <502>"
	exit
fi


WSFOLDER=anadroid-fsl
WSPATH=${AROOT}/${WSFOLDER}
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
if [ "${AVER}" = "4.2.2_r1" ]; then
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi

echo "**************************************************"
echo "ROOT=${AROOT}"
echo "AFOLDER=${AFOLDER}"
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

. build/envsetup.sh
lunch ${LUNCHTYPE}

make clean
java -version > ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
which java
uname -a >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
echo "ROOT=${AROOT}" >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
echo "AFOLDER=${AFOLDER}" >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
echo "AVER=${AVER}" >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
echo "LUNCHTYPE=${LUNCHTYPE}" >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
echo "**************************************************" >> ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt

touch startTIME
_TIMEBUILDSTART=$(date +"%s")
make -j${CPUS} ${BUPARAM} 2>&1 | tee -a ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
touch endTIME
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))


if [ "${AVER}" = "4.4.3_r1" ]; then
	touch startTIMEsd
	mkdir -p out/target/product/${BUBOARD}/NAND
	mv out/target/product/${BUBOARD}/boot*.img out/target/product/${BUBOARD}/NAND
	mv out/target/product/${BUBOARD}/recovery*.img out/target/product/${BUBOARD}/NAND
	rm -rf out/target/product/${BUBOARD}/root
	rm -rf out/target/product/${BUBOARD}/boot*.img
	rm -rf out/target/product/${BUBOARD}/recovery
	rm -rf out/target/product/${BUBOARD}/recovery*.img
	
	make -j${CPUS} bootimage BUILD_TARGET_DEVICE=sd 2>&1 | tee ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]sd-log.txt
	touch endTIMEsd
fi

cd ${AROOT}
echo `pwd`
echo "${_Br}#"
#echo "# download time=${_TIMEDOWNLOAD} seconds."
echo "# build    time=${_TIMEBUILD} seconds."
#echo "# mkubi    time=${_TIMEMKUBI} seconds."
echo "#${_Tr}"

# _E_O_F_
