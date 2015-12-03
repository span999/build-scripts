#!/bin/sh
#
# This script helps on linux kernel build ...

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red


_OPT_VER=$1
_OPT_BOOT=$2

_ROOT=`pwd`
_TARDIR=linux-at91
_SRCFOLDER=/home/span/workshop/git/android/atmel/android4sam/linux-boot
_SRCTARBALL=linux-at91_anrdroid4sam_v4.1.tar.bz2
_TOOLCHAINDIR=/home/span/workshop/bin/toolchains/atmel-arm-toolchain
#_TOOLCHAINPREFXI=arm-none-linux-gnueabi-
_TOOLCHAINPREFXI=arm-linux-gnueabihf-
_REPOROOT=https://n425.cee.mitac.com/svn/n425
#_SVNREPO=${_REPOROOT}/branches/user/span/atmel/linux-at91
_SVNREPO=${_REPOROOT}/branches/user/span/atmel/linux-at91_src
#_SVNPROJ=linux-at91_anrdroid4sam_v3.0
#_SVNPROJ=linux-at91_anrdroid4sam_v3.1
#_SVNPROJ=linux-at91_anrdroid4sam_v4.0
_SVNPROJ=linux-at91_anrdroid4sam_v4.1
#_SVNPROJ=linux-at91_anrdroid4sam_GC018-433
_SVNWS=/home/span/workshop/svn/checkout/n425/atmel/linux-3.6.9
_ROOTTARBALL=${_REPOROOT}/branches/user/span/atmel/script/ICS4SAMA5D3xEK/root.tar.bz2

_TIMEBUILDSTART=
_TIMEBUILDEND=
_TIMEBUILD=

_BOOTTYPE=NAND
#_BOOTTYPE=SD


# 0. config the build 
echo "${_Br}# "
echo "# config the build"
echo "# project ver.=${_OPT_VER}"
echo "# project boot.=${_OPT_BOOT}"
echo "# ${_Tr}"
if [ "${_OPT_VER}" == "3.0" ]; then
	_SVNPROJ=linux-at91_anrdroid4sam_v3.0
fi
if [ "${_OPT_VER}" == "3.1" ]; then
	_SVNPROJ=linux-at91_anrdroid4sam_v3.1
fi
if [ "${_OPT_VER}" == "4.0" ]; then
	_SVNPROJ=linux-at91_anrdroid4sam_v4.0
fi
if [ "${_OPT_VER}" == "4.1" ]; then
	_SVNPROJ=linux-at91_anrdroid4sam_v4.1
fi
if [ "${_OPT_VER}" == "gc018" ]; then
	_SVNPROJ=linux-at91_anrdroid4sam_GC018-433
fi
if [ "${_OPT_BOOT}" == "SD" ]; then
	_BOOTTYPE=SD
fi

# 1. get the source 
echo "${_Br}# "
echo "# get the source"
echo "# ${_Tr}" 
if [ -d ${_TARDIR} ]; then
	rm -rf ${_TARDIR}
	echo "${_Br}# "
	echo "# remove old folder first ..."
	echo "# ${_Tr}" 
fi

#tar -xvf ${_SRCFOLDER}/${_SRCTARBALL} > /dev/null
echo "${_Br}# "
echo "# repo=${_SVNREPO}/${_SVNPROJ}"
echo "# workspace=${_SVNWS}"
echo "# ${_Tr}"
if [ ! -d ${_SVNWS} ]; then
	svn co ${_SVNREPO}/${_SVNPROJ} ${_SVNWS} 
fi
svn sw ${_SVNREPO}/${_SVNPROJ} ${_SVNWS}
svn export ${_SVNWS} ${_TARDIR}

# 2. config the source 
echo "${_Br}# "
echo "# config the source"
cd ${_TARDIR}
echo "# now@`pwd`"
if [ ${_BOOTTYPE} == "NAND" ]; then
	_CFG=sama5d3_android_ubifs_defconfig
fi
if [ ${_BOOTTYPE} == "SD" ]; then
	_CFG= sama5d3_android_sdcard_defconfig
fi
echo "# boot from <${_BOOTTYPE}>"
echo "# config as <${_CFG}>"
echo "# ${_Tr}"
svn export ${_REPOROOT}/branches/user/span/atmel/script/ICS4SAMA5D3xEK/root.tar.bz2
tar -xvf ./root.tar.bz2
#tar -xvf ${_SRCFOLDER}/root.tar.bz2
# ignore ARCH & CROSS_COMPILE hard code setting
sed -i 's/ARCH = arm/#ARCH = arm/g' Makefile
sed -i 's/CROSS_COMPILE = arm-linux-gnueabihf-/#CROSS_COMPILE = arm-linux-gnueabihf-/g' Makefile
make mrproper
make ARCH=arm ${_CFG}

if [ "${_SVNPROJ}" == "linux-at91_anrdroid4sam_GC018-433" ]; then
	echo "${_Br}# "
	echo "# ******* override GC018 touchscreen setting *******"
	echo "# ${_Tr}"
	sed -i 's/CONFIG_INPUT_TOUCHSCREEN=y/# CONFIG_INPUT_TOUCHSCREEN is not set/g' .config
fi 

# 3. compile
echo "${_Br}# "
echo "# compile the source"
echo "# ${_Tr}"

_TIMEBUILDSTART=$(date +"%s")
make -j4 ARCH=arm CROSS_COMPILE=${_TOOLCHAINDIR}/bin/${_TOOLCHAINPREFXI} uImage
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
echo "${_Br}# "
echo "# build time=${_TIMEBUILD} seconds."
echo "# ${_Tr}"
echo "-----------------------------------------------------------------------------"
echo "${_Br}"
ls arch/arm/boot -al
echo "${_Tr}"
echo "-----------------------------------------------------------------------------"

_TIMEBUILDSTART=$(date +"%s")
make -j4 ARCH=arm CROSS_COMPILE=${_TOOLCHAINDIR}/bin/${_TOOLCHAINPREFXI} dtbs
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
echo "${_Br}# "
echo "# build time=${_TIMEBUILD} seconds."
echo "# ${_Tr}"
echo "-----------------------------------------------------------------------------"
echo "${_Br}"
ls arch/arm/boot/dts/sam*
ls arch/arm/boot/dts/at*
echo "${_Tr}"
echo "-----------------------------------------------------------------------------"

cd ${_ROOT}
exit 0

