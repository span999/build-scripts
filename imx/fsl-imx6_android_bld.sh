#!/bin/sh
#
# sudo update-alternatives --config java (choose as needed)
# sudo update-alternatives --config javac (choose as needed)
# sudo apt-get install uuid-dev (L5 no need)
# sudo apt-get install liblzo2-dev (L5 no need)
#


NOWTIME=`date +%y%m%d-%02k%02M%02S`
AROOT=`pwd`
CPUS=8

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


AFOLDER=android-${AVER}
#BUBOARD=aosp_arm-eng  #for original android build
BUBOARD=sabresd_6dq
#BUMODE=user
BUMODE=eng
LUNCHTYPE=${BUBOARD}-${BUMODE}
BUPARAM=

if [ "${AVER}" = "5.0.2_r1" ]; then
	BUBOARD=sabresd_6dq
	BUMODE=user
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

cd ${AROOT}
cd ${AFOLDER}
echo `pwd`

export USE_CCACHE=1
#export CCACHE_DIR=~/.accache
export CCACHE_DIR=~/.ccache
prebuilts/misc/linux-x86/ccache/ccache -M 25G
#prebuilts/misc/linux-x86/ccache/ccache -M 17G

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
make -j${CPUS} ${BUPARAM} 2>&1 | tee -a ${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]-log.txt
#make -j12 BUILD_TARGET_DEVICE=sd 2>&1 | tee ${AROOT}/logs/build-${NOWTIME}-log.txt
touch endTIME

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

# _E_O_F_
