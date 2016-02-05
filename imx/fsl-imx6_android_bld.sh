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
	echo "no user input !! try <443> or <422> or <502> or <rogue> or <sabresd_6dq>"
	exit
fi

if [ "${USERIN}" = "443" -o "${USERIN}" = "422" -o "${USERIN}" = "502" -o "${USERIN}" = "rogue" -o "${USERIN}" = "sabresd_6dq" ]; then
	echo "  user input =<${USERIN}> para1 =<${USERP1}>"
	if [ "${USERIN}" = "443" -o "${USERIN}" = "rogue" -o "${USERIN}" = "sabresd_6dq" ]; then
		AVER=4.4.3_r1
	fi
	if [ "${USERIN}" = "422" ]; then
		AVER=4.2.2_r1
	fi
	if [ "${USERIN}" = "502" -o "${USERIN}" = "n425-50" ]; then
		AVER=5.0.2_r1
	fi
else
	echo "wrong user input !! try <443> or <422> or <502> or <rogue>"
	exit
fi


if [ "${USERIN}" = "rogue" -o "${USERIN}" = "sabresd_6dq" ]; then
	WSFOLDER=rogue-fsl
else
	WSFOLDER=anadroid-fsl
fi
WSPATH=${AROOT}/${WSFOLDER}
OUT_DIR=${AROOT}/${WSFOLDER}/out
AFOLDER=android-${AVER}
#BUBOARD=aosp_arm-eng  #for original android build
#for EVK
BUBOARD=sabresd_6dq
#BUMODE=user
BUMODE=eng
LUNCHTYPE=${BUBOARD}-${BUMODE}
BUPARAM=
ACROSS_COMPILE=prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
KDEFCONF=imx_v7_android_defconfig
UDEFCONF=mx6qsabresdandroid_config

if [ "${AVER}" = "5.0.2_r1" ]; then
	BUBOARD=sabresd_6dq
	#BUMODE=user
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
	#BUPARAM="BUILD_TARGET_DEVICE=sd"
	ACROSS_COMPILE=prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
fi
if [ "${AVER}" = "4.4.3_r1" ]; then
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi
if [ "${USERIN}" = "rogue" ]; then
	BUMODE=eng
	#for rogue n535
	BUBOARD=sabresd_6dq_n535
	LUNCHTYPE=${BUBOARD}-${BUMODE}
	KDEFCONF=imx_v7_android_rogue_defconfig
fi
if [ "${USERIN}" = "sabresd_6dq" ]; then
	BUMODE=eng
	BUBOARD=sabresd_6dq
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi
if [ "${AVER}" = "4.2.2_r1" ]; then
	BUMODE=eng
	LUNCHTYPE=${BUBOARD}-${BUMODE}
fi
if [ "${AVER}" = "4.4.3_r1" ]; then
	#export JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
	export JAVA_HOME=/home/span/workshop/bin/jdk1.6.0_45
	export PATH=/home/span/workshop/bin/jdk1.6.0_45/bin:$PATH
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
echo "BUPARAM=${BUPARAM}"
echo "**************************************************"

cd ${WSPATH}
cd ${AFOLDER}
echo `pwd`

export USE_CCACHE=1
#export CCACHE_DIR=~/.ccache
#prebuilts/misc/linux-x86/ccache/ccache -M 25G
CCACHE_BIN=`find ./ -type f -path "*linux-x86*" -name \ccache`
${CCACHE_BIN} -M 25G


if [ "kernel" = "${USERP1}" ]; then
	LOGFILE=${AROOT}/logs/kbuild-${NOWTIME}-[]-log.txt
	echo "" >> ${LOGFILE}

	cd kernel_imx
	_TIMEBUILDSTART=$(date +"%s")
	make distclean ARCH=arm
	make ${KDEFCONF} ARCH=arm CROSS_COMPILE=${WSPATH}/${AFOLDER}/${ACROSS_COMPILE}
	make uImage LOADADDR=0x10008000 -j12 ARCH=arm CROSS_COMPILE="ccache ${WSPATH}/${AFOLDER}/${ACROSS_COMPILE}" 2>&1 | tee -a ${LOGFILE}
	_TIMEBUILDEND=$(date +"%s")
	_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

	echo "" >> ${LOGFILE}
	echo "# build    time=${_TIMEBUILD} seconds." >> ${LOGFILE}
	echo "" >> ${LOGFILE}
	cd -
	exit 0
fi

if [ "uboot" = "${USERP1}" ]; then
	LOGFILE=${AROOT}/logs/ubuild-${NOWTIME}-[]-log.txt
	echo "" >> ${LOGFILE}

	cd bootable/bootloader/uboot-imx
	_TIMEBUILDSTART=$(date +"%s")
	make distclean ARCH=arm
	make ${UDEFCONF} ARCH=arm CROSS_COMPILE=${WSPATH}/${AFOLDER}/${ACROSS_COMPILE}
	make -j12 ARCH=arm CROSS_COMPILE="ccache ${WSPATH}/${AFOLDER}/${ACROSS_COMPILE}" 2>&1 | tee -a ${LOGFILE}
	_TIMEBUILDEND=$(date +"%s")
	_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

	echo "" >> ${LOGFILE}
	echo "# build    time=${_TIMEBUILD} seconds." >> ${LOGFILE}
	echo "" >> ${LOGFILE}
	cd -
	exit 0
fi

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
echo "BUPARAM=${BUPARAM}" >> ${LOGFILE}
echo "**************************************************" >> ${LOGFILE}

OUTTARGETBOARD=${OUT_DIR}/${AFOLDER}/target/product/${BUBOARD}
if [ "fast" = "${USERP1}" ]; then
	echo "fast build, NOT doing clean on out..." >> ${LOGFILE}
	rm -rf ${OUTTARGETBOARD}/*.img
	rm -rf ${OUTTARGETBOARD}/u-boot*.*
	rm -rf ${OUTTARGETBOARD}/NAND
	rm -rf ${OUTTARGETBOARD}/SDMMC
fi

if [ "bootimage" = "${USERP1}" ]; then
	echo "bootimage only, NOT doing clean on out..." >> ${LOGFILE}
	rm -rf ${OUTTARGETBOARD}/boot*.img
	rm -rf ${OUTTARGETBOARD}/root

	touch startTIME
	_TIMEBUILDSTART=$(date +"%s")
	make bootimage -j${CPUS} ${BUPARAM} 2>&1 | tee -a ${LOGFILE}
	touch endTIME
	_TIMEBUILDEND=$(date +"%s")
	_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

	echo "" >> ${LOGFILE}
	echo "# build    time=${_TIMEBUILD} seconds." >> ${LOGFILE}
	echo "" >> ${LOGFILE}

	BUPARAM="BUILD_TARGET_DEVICE=sd"
	SDLOGFILE=${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]sd-log.txt
	touch startTIMEsd
	mkdir -p ${OUTTARGETBOARD}/NAND
	mv -f ${OUTTARGETBOARD}/boot*.img ${OUTTARGETBOARD}/NAND
	rm -rf ${OUTTARGETBOARD}/root
	rm -rf ${OUTTARGETBOARD}/boot*.img
	
	echo "**************************************************" >> ${SDLOGFILE}
	echo "JAVA version=${JAVAVER}" >> ${SDLOGFILE}
	echo "System name=${SYSTEMNAME}" >> ${SDLOGFILE}
	echo "ROOT=${AROOT}" >> ${SDLOGFILE}
	echo "AFOLDER=${AFOLDER}" >> ${SDLOGFILE}
	echo "OUT_DIR=${OUT_DIR}" >> ${SDLOGFILE}
	echo "AVER=${AVER}" >> ${SDLOGFILE}
	echo "LUNCHTYPE=${LUNCHTYPE}" >> ${SDLOGFILE}
	echo "BUPARAM=${BUPARAM}" >> ${SDLOGFILE}
	#echo "bootimage BUILD_TARGET_DEVICE=sd" >> ${SDLOGFILE}
	echo "**************************************************" >> ${SDLOGFILE}	
	echo "bootimage only, NOT doing clean on out..." >> ${SDLOGFILE}

	_TIMEBUILDSTARTSD=$(date +"%s")
	#make -j${CPUS} bootimage ${BUPARAM} 2>&1 | tee -a ${SDLOGFILE}
	make bootimage -j${CPUS} ${BUPARAM} 2>&1 | tee -a ${SDLOGFILE}
	_TIMEBUILDENDSD=$(date +"%s")
	_TIMEBUILDSD=$(($_TIMEBUILDENDSD-$_TIMEBUILDSTARTSD))
	touch endTIMEsd

	mkdir -p ${OUTTARGETBOARD}/SDMMC
	cp -f ${OUTTARGETBOARD}/boot*.img ${OUTTARGETBOARD}/SDMMC

	echo "" >> ${SDLOGFILE}
	echo "# build    time=${_TIMEBUILDSD} seconds." >> ${SDLOGFILE}
	echo "" >> ${SDLOGFILE}

	exit 0
fi

if [ "fast" = "${USERP1}" -o "bootimage" = "${USERP1}" ]; then
	echo ""
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




if [ "${AVER}" = "4.4.3_r1" -o "${AVER}" = "5.0.2_r1" ]; then
	BUPARAM="BUILD_TARGET_DEVICE=sd"
	SDLOGFILE=${AROOT}/logs/build-${NOWTIME}-[${LUNCHTYPE}]sd-log.txt
	touch startTIMEsd
	mkdir -p ${OUTTARGETBOARD}/NAND
	mv ${OUTTARGETBOARD}/boot*.img ${OUTTARGETBOARD}/NAND
	mv ${OUTTARGETBOARD}/recovery*.img ${OUTTARGETBOARD}/NAND
	mv ${OUTTARGETBOARD}/system.img ${OUTTARGETBOARD}/NAND
	rm -rf ${OUTTARGETBOARD}/root
	rm -rf ${OUTTARGETBOARD}/boot*.img
	rm -rf ${OUTTARGETBOARD}/recovery
	rm -rf ${OUTTARGETBOARD}/recovery*.img
	if [ "${AVER}" = "5.0.2_r1" ]; then
		rm -rf ${OUTTARGETBOARD}/system
		rm -rf ${OUTTARGETBOARD}/system.img
	fi
	
	echo "**************************************************" >> ${SDLOGFILE}
	echo "JAVA version=${JAVAVER}" >> ${SDLOGFILE}
	echo "System name=${SYSTEMNAME}" >> ${SDLOGFILE}
	echo "ROOT=${AROOT}" >> ${SDLOGFILE}
	echo "AFOLDER=${AFOLDER}" >> ${SDLOGFILE}
	echo "OUT_DIR=${OUT_DIR}" >> ${SDLOGFILE}
	echo "AVER=${AVER}" >> ${SDLOGFILE}
	echo "LUNCHTYPE=${LUNCHTYPE}" >> ${SDLOGFILE}
	echo "BUPARAM=${BUPARAM}" >> ${SDLOGFILE}
	#echo "bootimage BUILD_TARGET_DEVICE=sd" >> ${SDLOGFILE}
	echo "**************************************************" >> ${SDLOGFILE}
	
	_TIMEBUILDSTARTSD=$(date +"%s")
	#make -j${CPUS} bootimage ${BUPARAM} 2>&1 | tee -a ${SDLOGFILE}
	make -j${CPUS} ${BUPARAM} 2>&1 | tee -a ${SDLOGFILE}
	_TIMEBUILDENDSD=$(date +"%s")
	_TIMEBUILDSD=$(($_TIMEBUILDENDSD-$_TIMEBUILDSTARTSD))
	touch endTIMEsd

	mkdir -p ${OUTTARGETBOARD}/SDMMC
	cp ${OUTTARGETBOARD}/boot*.img ${OUTTARGETBOARD}/SDMMC
	cp ${OUTTARGETBOARD}/recovery*.img ${OUTTARGETBOARD}/SDMMC
	if [ "${AVER}" = "5.0.2_r1" ]; then
		cp ${OUTTARGETBOARD}/system.img ${OUTTARGETBOARD}/SDMMC
	fi

	echo "#!/bin/sh" > ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh
	echo "#" >> ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh
	echo "" >> ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh
	echo "sudo dd if=../u-boot-imx6q.imx of=/dev/sde bs=1k seek=1; sync" >> ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh
	echo "sudo dd if=boot.img of=/dev/sde1; sync" >> ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh
	echo "sudo dd if=recovery.img of=/dev/sde2; sync" >> ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh
	echo "sudo dd if=system.img of=/dev/sde5; sync" >> ${OUTTARGETBOARD}/SDMMC/dd.sdmmc.sh

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
