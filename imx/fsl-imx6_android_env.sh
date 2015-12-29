#!/bin/sh
#

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red

NOWTIME=`date +%y%m%d-%02k%02M%02S`
AROOT=`pwd`
#AVER=5.0.2_r1
AVER=4.4.3_r1
#AVER=4.2.2_r1
SRCURL1=192.168.2.103
SRCURL2=10.60.103.234
SRCURL=${SRCURL2}

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


if [ "${AVER}" = "5.0.2_r1" ]; then
	TARBALLDIR=/home/span/workshop/git/android/tarball
	aTARBALL=android-5.0.2_r1_src_imx.tar.xz
	kTARBALL=kernel_imx_src_l5.0.0_1.0.0-ga.tar.xz
	uTARBALL=uboot-imx_src_l5.0.0_1.0.0-ga.tar.xz
	#external/chromium_org/third_party/angle/src/commit_id.target.linux-arm.mk
	aTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/L5/${aTARBALL}
	kTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/L5/${kTARBALL}
	uTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/L5/${uTARBALL}
fi
if [ "${AVER}" = "4.4.3_r1" ]; then
	if [ "${USERIN}" = "rogue" ]; then
	echo "setup for rogue build."
	else
	TARBALLDIR=/home/span/workshop/git/android/tarball
	aTARBALL=android-4.4.3_r1_src_imx_patched.tar.xz
	kTARBALL=kernel_imx_src_kk4.4.3_2.0.0-ga.tar.xz
	uTARBALL=uboot-imx_src_kk4.4.3_2.0.0-ga.tar.xz
	aTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/kk4.4.3/${aTARBALL}
	kTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/kk4.4.3/${kTARBALL}
	uTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/kk4.4.3/${uTARBALL}
	PATCH001=linux-2.6-imx-d40d224c1db101382b14753520aa3408715380e3.patch
	fi
fi
if [ "${AVER}" = "4.2.2_r1" ]; then
	TARBALLDIR=/home/span/workshop/git/android/tarball
	aTARBALL=android_src_jb4.2.2_1.1.0-ga-patched.tar.xz
	kTARBALL=kernel_imx_src_jb4.2.2_1.1.0-ga.tar.xz
	uTARBALL=uboot-imx_src_jb4.2.2_1.1.0-ga.tar.xz
	aTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/jb4.2.2/${aTARBALL}
	kTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/jb4.2.2/${kTARBALL}
	uTARURL=ftp://ftpuser:ftpuser@${SRCURL}/home/freescale/src/jb4.2.2/${uTARBALL}
fi


if [ "${USERIN}" = "rogue" ]; then
	WSFOLDER=rogue-fsl
else
	WSFOLDER=anadroid-fsl
fi
WSPATH=${AROOT}/${WSFOLDER}
AFOLDER=android-${AVER}

if [ "${USERIN}" = "rogue" ]; then
	if [ ! -d ${WSPATH} ]; then
		mkdir -p ${WSPATH} 
	fi
	cd ${WSPATH}
	if [ ! -d ${AFOLDER} ]; then
		git clone git@mbg-rd4-codesvr.mic.com.tw:n535/android-4.4.3_r1.git ${AFOLDER} -b N535-Rogue-AVM
		##git clone git@113.196.154.157:n535/android-4.4.3_r1.git ${AFOLDER} -b N535-Rogue-AV
	fi
	cd ${AFOLDER}
	git checkout N535-Rogue-AVM
	git pull
	cd -

	if [ ! -d kernel_imx ]; then
		git clone git@mbg-rd4-codesvr.mic.com.tw:n535/kernel_imx.git kernel_imx -b N535-Rogue-AVM
		##git clone git@113.196.154.157:n535/kernel_imx.git kernel_imx -b N535-Rogue-AVM
	fi
	cd kernel_imx
	git checkout N535-Rogue-AVM
	git pull
	cd -

	if [ ! -d uboot-imx  ]; then
		git clone git@mbg-rd4-codesvr.mic.com.tw:n535/uboot-imx.git uboot-imx -b N535-Rogue-AVM
		##git clone git@113.196.154.157:n535/uboot-imx.git uboot-imx -b N535-Rogue-AVM
	fi
	cd uboot-imx 
	git checkout N535-Rogue-AVM
	git pull
	cd -
	
	echo ""
	echo "ready for rogue build."
	exit 0
fi

echo "**************************************************"
echo "build folder root=${AROOT}"
echo "android folder name=${AFOLDER}"
echo "android tarball=${aTARBALL}"
echo "linux kernel tarball=${kTARBALL}"
echo "u-boot tarball=${uTARBALL}"
echo "**************************************************"

#export JAVA_HOME=/home/workshop/bin/jdk1.6.0_45/bin
#export PATH=/home/workshop/bin/jdk1.6.0_45/bin:$PATH
if [ ! -d ${WSFOLDER} ]; then
	mkdir -p ${WSPATH}
fi
cd ${WSPATH}
echo $PATH
which java
java -version

if [ ! -d ${TARBALLDIR} ]; then
	mkdir -p ${TARBALLDIR}
fi

cd ${TARBALLDIR}
if [ ! -f ${aTARBALL} ]; then
	wget ${aTARURL}
fi
if [ ! -f ${kTARBALL} ]; then
	wget ${kTARURL}
fi
if [ ! -f ${uTARBALL} ]; then
	wget ${uTARURL}
fi
cd -

echo "killing old build tree ... "
rm -rf ${AVER}_src
#rm -rf myandroid
rm -rf ${AFOLDER}
if [ "clean" = "${USERP1}" -o "clr" = "${USERP1}" -o "c" = "${USERP1}" ]; then
	echo "clean done ... "
	cd ${AROOT}
	echo $PATH
	exit
fi

echo "restore build tree ... "
mkdir ${AVER}_src
tar xvf ${TARBALLDIR}/${aTARBALL} -C ${AVER}_src/
ln -s ${AVER}_src/myandroid ${AFOLDER}

cd ${AFOLDER}
tar xvf ${TARBALLDIR}/${kTARBALL}
cd -
cd ${AFOLDER}/bootable/bootloader
tar xvf ${TARBALLDIR}/${uTARBALL}
cd -

if [ "${AVER}" = "5.0.2_r1" ]; then
	cp -f ${TARBALLDIR}/commit_id.target.linux-arm.mk ${AFOLDER}/external/chromium_org/third_party/angle/src/commit_id.target.linux-arm.mk
fi
if [ "${AVER}" = "4.4.3_r1" ]; then
	cd ${AFOLDER}/kernel_imx
	patch -p1 < ${TARBALLDIR}/${PATCH001}
	cd -
fi

cd ${AROOT}
echo $PATH

# _E_O_F_
