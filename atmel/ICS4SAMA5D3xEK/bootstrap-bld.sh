#!/bin/sh
#
# This script helps on bootstrap build ...
#
# param1 = revision (3.0, 3.1, 4.0, 4.1, default=4.1) 
# param1 = revision (NAND, SD, default=NAND)
#

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red


_OPT_VER=$1
_OPT_BOOT=$2

_ROOT=`pwd`
_TARDIR=at91bootstrap
_SRCFOLDER=/home/span/workshop/git/android/atmel/android4sam/linux-boot
_SRCTARBALL=at91bootstrap_anrdroid4sam_v4.1.tar.bz2
_TOOLCHAINDIR=/home/span/workshop/bin/toolchains/atmel-arm-toolchain
#_TOOLCHAINPREFXI=arm-none-linux-gnueabi-
_TOOLCHAINPREFXI=arm-linux-gnueabihf-
_REPOROOT=https://n425.cee.mitac.com/svn/n425
#_SVNREPO=${_REPOROOT}/branches/user/span/atmel/at91bootstrap
_SVNREPO=${_REPOROOT}/branches/user/span/atmel/at91bootstrap_src
#_SVNPROJ=at91bootstrap_anrdroid4sam_v3.0
#_SVNPROJ=at91bootstrap_anrdroid4sam_v3.1
#_SVNPROJ=at91bootstrap_anrdroid4sam_v4.0
_SVNPROJ=at91bootstrap_anrdroid4sam_v4.1
_SVNWS=/home/span/workshop/svn/checkout/n425/atmel/at91bootstrap

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
	_SVNPROJ=at91bootstrap_anrdroid4sam_v3.0
fi
if [ "${_OPT_VER}" == "3.1" ]; then
	_SVNPROJ=at91bootstrap_anrdroid4sam_v3.1
fi
if [ "${_OPT_VER}" == "4.0" ]; then
	_SVNPROJ=at91bootstrap_anrdroid4sam_v4.0
fi
if [ "${_OPT_VER}" == "4.1" ]; then
	_SVNPROJ=at91bootstrap_anrdroid4sam_v4.1
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
# for NAND boot
if [ ${_BOOTTYPE} == "NAND" ]; then
	_CFG=sama5d3xeknf_android_dt_defconfig
	if [ ${_SVNPROJ} == "at91bootstrap_anrdroid4sam_v3.1" ]; then
		_CFG=at91sama5d3xeknf_android_dt_defconfig
	fi
fi
# for SD boot
if [ ${_BOOTTYPE} == "SD" ]; then
	_CFG=sama5d3xeksd_android_dt_defconfig
	if [ ${_SVNPROJ} == "at91bootstrap_anrdroid4sam_v3.1" ]; then
		_CFG=at91sama5d3xeksd_android_dt_defconfig
	fi
fi
echo "# boot from <${_BOOTTYPE}>"
echo "# config as <${_CFG}>"
echo "# ${_Tr}" 
make mrproper
make ${_CFG}

# 3. compile
echo "${_Br}# "
echo "# compile the source"
echo "# ${_Tr}"

_TIMEBUILDSTART=$(date +"%s")
make -j4 ARCH=arm CROSS_COMPILE=${_TOOLCHAINDIR}/bin/${_TOOLCHAINPREFXI}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
echo "${_Br}# "
echo "# build time=${_TIMEBUILD} seconds."
echo "# ${_Tr}"
echo "-----------------------------------------------------------------------------"
echo "${_Br}" 
ls -al binaries
echo "${_Tr}" 
echo "-----------------------------------------------------------------------------"

cd ${_ROOT}
exit 0

