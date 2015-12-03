#!/bin/sh
#

#
#
#

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red
TODAY=`date +%Y%m%d%02k%02M%02S`

ROT_PATH=`pwd`
WS_BASE=/home/span/workshop
SRC_BASE=${WS_BASE}/git/android/android-4.3_r2
SVN_ROOT=https://n425.cee.mitac.com/svn/n425

#SRCVER=android-4.3_r2
SRCVER=android-4.2.2_r1.1
#SRCVER=android-4.0.4_r2.1

PROJNAME1=android-4.3_r2
PROJNAME2=android-4.3_r1.1
PROJNAME3=android-4.2.2_r1.1
PROJNAME4=android-4.0.4_r2.1
PROJNAME5=android-4.0.4_r1.1
PROJNAME6=android-4.4.2_r1
PROJNAME7=android-4.4.4_r1
PROJNAME8=android-4.4.4_r2
PROJNAME9=android-4.4w_r1
PROJNAMEa=android4sam_v3.0
PROJNAMEb=android4sam_v3.1
PROJNAMEc=android4sam_v4.0
PROJNAMEd=android4sam_v4.1
PROJNAMEe=GC018_rev433
PROJNAMEf=android-hammerhead
PROJNAMEg=android-flo
PROJNAMEh=android-grouper

echo "${_Br}#"
echo "# <<<supported project list>>> "
echo "# 1. ${PROJNAME1} "
echo "# 2. ${PROJNAME2} "
echo "# 3. ${PROJNAME3} "
echo "# 4. ${PROJNAME4} (X)"
echo "# 5. ${PROJNAME5} (X)"
echo "# 6. ${PROJNAME6} "
echo "# 7. ${PROJNAME7} "
echo "# 8. ${PROJNAME8} "
echo "# 9. ${PROJNAME9} "
echo "# a. ${PROJNAMEa} (X)"
echo "# b. ${PROJNAMEb} (X) 4.0.4_r2.1"
echo "# c. ${PROJNAMEc} (V) 4.2.2_r1.1"
echo "# d. ${PROJNAMEd} (V) 4.2.2_r1.1"
echo "# e. ${PROJNAMEe} "
echo "# f. ${PROJNAMEf} (V) 4.4.4_r2"
echo "# g. ${PROJNAMEg} (V) 4.4.4_r1"
echo "# h. ${PROJNAMEh} (V) 4.3_r1.1"
echo "# "
echo "# What do you like to do?! "
echo "# key in the number...${_Tr}"

read USERPROJ

case ${USERPROJ} in
	1 ) SRCVER=${PROJNAME1};;
	2 ) SRCVER=${PROJNAME2};;
	3 ) SRCVER=${PROJNAME3};;
	4 ) SRCVER=${PROJNAME4};;
	5 ) SRCVER=${PROJNAME5};;
	6 ) SRCVER=${PROJNAME6};;
	7 ) SRCVER=${PROJNAME7};;
	8 ) SRCVER=${PROJNAME8};;
	9 ) SRCVER=${PROJNAME9};;
	a ) SRCVER=${PROJNAMEa};;
	b ) SRCVER=${PROJNAMEb};;
	c ) SRCVER=${PROJNAMEc};;
	d ) SRCVER=${PROJNAMEd};;
	e ) SRCVER=${PROJNAMEe};;
	f ) SRCVER=${PROJNAMEf};;
	g ) SRCVER=${PROJNAMEg};;
	h ) SRCVER=${PROJNAMEh};;
	* ) 
		echo "${_Br}   Unknown input !! ${_Tr}"
		exit 0;;
esac


CCACHE_SIZE=5G
if [ ${SRCVER} == "android-4.3_r2" ]; then
	#USESRC=TARBALL
	USESRC=SVN
	#SRCTARPATH=${WS_BASE}/git/android
	SRCTARPATH=${WS_BASE}/temp
	#SRCTARBALL=${SRCVER}.tar.xz
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.3_r2
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.3_r1.1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	#SRCTARPATH=${WS_BASE}/git/android
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.3_r2
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.2.2_r1.1" ]; then
	#USESRC=TARBALL
	USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.2.2_r1.1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.0.4_r2.1" ]; then
	USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.0.4_r2.1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilt/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.0.4_r1.1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.0.4_r2.1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilt/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.4.2_r1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.4.2_r1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.4.4_r1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.4.2_r1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.4.4_r2" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.4.2_r1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-4.4w_r1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.4.2_r1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi

if [ ${SRCVER} == "android4sam_v3.0" ]; then
	USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/atmel/android4sam-src2/android4sam_v3.0
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilt/linux-x86/ccache
fi
if [ ${SRCVER} == "android4sam_v3.1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	#SRCTARPATH=${WS_BASE}/temp
	SRCTARPATH=${WS_BASE}/git/android/atmel/android4sam/android
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/atmel/android4sam-src2/android4sam_v3.1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilt/linux-x86/ccache
fi
if [ ${SRCVER} == "android4sam_v4.0" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	#SRCTARPATH=${WS_BASE}/temp
	SRCTARPATH=${WS_BASE}/git/android/atmel/android4sam/android
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android4sam_v4.0
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android4sam_v4.1" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	#SRCTARPATH=${WS_BASE}/temp
	SRCTARPATH=${WS_BASE}/git/android/atmel/android4sam/android
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android4sam_v4.1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "GC018_rev433" ]; then
	#USESRC=TARBALL
	USESRC=SVN
	#SRCTARPATH=${WS_BASE}/temp
	SRCTARPATH=${WS_BASE}/workshop/git/android/atmel/android4sam/android
	#SRCTARBALL=${SRCVER}.tar.bz2
	SRCNAME=${SRCVER}
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/atmel/android4sam-src2/GC018_rev433
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilt/linux-x86/ccache
fi
if [ ${SRCVER} == "android-hammerhead" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	#SRCTARBALL=${SRCVER}.tar.xz
	SRCNAME=android-4.4.4_r2
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.4.2_r1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-flo" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=android-4.4.4_r1
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.4.2_r1
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi
if [ ${SRCVER} == "android-grouper" ]; then
	USESRC=TARBALL
	#USESRC=SVN
	#SRCTARPATH=${WS_BASE}/git/android
	SRCTARPATH=${WS_BASE}/temp
	SRCNAME=android-4.3_r1.1
	SRCTARBALL=${SRCNAME}.tar.xz
	SVNREPO=${SVN_ROOT}/branches/user/span/android/android-4.3_r2
	SVNWS=${WS_BASE}/svn/checkout/n425/android/android-src
	CCACHE_PATH=prebuilts/misc/linux-x86/ccache
fi


if [ ${USESRC} == "" ]; then
	echo "${_Br}#"
	echo "# <<<No match project. exit !>>> "
	echo "#${_Tr}"
	exit 0
else
	echo "${_Br}#"
	echo "# <<<user select ${SRCVER} !>>> "
	echo "#${_Tr}"
fi

BLD_LINK=android-src
#BLD_LINK=${SRCVER}-src
BLD_BASE=${ROT_PATH}/${BLD_LINK}
CCACHE_BASE=${BLD_BASE}/${CCACHE_PATH}
CCACHE_BIN=${CCACHE_BASE}/ccache

REL_BASE=${ROT_PATH}
OUT_PATH=${REL_BASE}/aout
LOG_PATH=${REL_BASE}/log
LOG_PREFIX=abuild-${TODAY}
BLD_LOG=${LOG_PATH}/${LOG_PREFIX}-bld.log
BLD_PKG_LOG=${LOG_PATH}/${LOG_PREFIX}-pkg.log
BLD_RCV_LOG=${LOG_PATH}/${LOG_PREFIX}-recovery.log
BLD_OTA_LOG=${LOG_PATH}/${LOG_PREFIX}-OTA.log
IMG_PATH=${OUT_PATH}/${BLD_LINK}/target/product

IS_ATMEL=no
IS_KITKAT=no

_TIMEBUILDSTART=
_TIMEBUILDEND=
_TIMEBUILD=


export JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
echo "${_Br}#"
echo "# <<<JAVA_HOME=${JAVA_HOME}>>> "
echo "#${_Tr}"

echo "${_Br}#"
echo "# <<<about to build android image for ${SRCVER} project ...>>> "
echo "# current path=`pwd`"
echo "#${_Tr}"


echo "${_Br}#"
echo "# <<<download source code (${USESRC})...>>> "
echo "#${_Tr}"
_TIMEDOWNLOAD=0
_TIMEBUILDSTART=$(date +"%s")
if [ ! -d ${SRCVER} ]; then
	if [ ${USESRC} == "TARBALL" ]; then
		if [ -f ${SRCTARPATH}/${SRCTARBALL} ]; then
			tar xf ${SRCTARPATH}/${SRCTARBALL}
		else
			echo "${_Br}#"
			echo "# <<< ${SRCTARPATH}/${SRCTARBALL} >>> "
			echo "# <<<tarball not found ...>>> "
			echo "#${_Tr}"
			exit 0
		fi
	fi
	if [ ${USESRC} == "SVN" ]; then
		svn sw ${SVNREPO} ${SVNWS}
		svn export ${SVNWS} ${SRCVER}
	fi
fi
_TIMEBUILDEND=$(date +"%s")
_TIMEDOWNLOAD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))


echo "${_Br}#"
echo "# <<<create link ...>>> "
echo "#${_Tr}"
if [ -L ${BLD_LINK} ]; then
	rm -rf ${BLD_LINK}
fi
#ln -s ${SRC_BASE} ${BLD_LINK}
ln -s ${SRCVER} ${BLD_LINK}
if [ ${SRCVER} == ${SRCNAME} ]; then
	#ln -s ${SRCNAME} ${SRCVER}
	echo "nothing to do ... "
else
	ln -s ${SRCNAME} ${SRCVER}
fi 

echo "${_Br}#"
echo "# <<<setup ccatch ...>>> "
echo "#${_Tr}"
CCACHE_BIN=`find ${BLD_LINK}/${CCACHE_PATH} -name ccache -path "*linux-x86*" -type f`
if [ ${CCACHE_BIN} == "" ]; then
	CCACHE_BIN=/usr/bin/ccache
fi
if [ -f ${CCACHE_BIN} ]; then
	echo "${_Br}#"
	echo "# ${CCACHE_BIN}"
	echo "# setup ccache -M ${CCACHE_SIZE} ..."
	echo "#${_Tr}"
	export USE_CCACHE=1
	${CCACHE_BIN} -M ${CCACHE_SIZE}
fi

echo "${_Br}#"
echo "# <<<create output folder ...>>> "
echo "#${_Tr}"
if [ -d ${OUT_PATH} ]; then 
	echo "${_Br}#"
	echo "# remove old out folder ..."
	echo "#${_Tr}"
	rm -rf ${OUT_PATH}
fi
mkdir -p ${OUT_PATH}
echo "${_Br}#"
echo "# set output to ${OUT_PATH} ..."
echo "#${_Tr}"
export OUT_DIR_COMMON_BASE=${OUT_PATH}
# for ICS or under
export OUT_DIR=${OUT_PATH}

cd ${BLD_LINK}
echo "${_Br}#"
echo "# current path=`pwd`"
echo "# "
echo "# setup build env ..."
echo "#${_Tr}"
. build/envsetup.sh

echo "${_Br}#"
echo "# setup ${SRCVER} build with development configuration ..."
echo "#${_Tr}"
### check if it's atmel platform
if [ ${SRCVER} == "android4sam_v3.0" -o ${SRCVER} == "android4sam_v3.1" -o ${SRCVER} == "android4sam_v4.0" -o ${SRCVER} == "android4sam_v4.1" -o ${SRCVER} == "GC018_rev433" ]; then
	IS_ATMEL=yes
fi
### check if it's KitKat 
if [ ${SRCVER} == "android-4.4.2_r1" -o ${SRCVER} == "android-4.4.4_r1" -o ${SRCVER} == "android-4.4.4_r2" -o ${SRCVER} == "android-hammerhead" -o ${SRCVER} == "android-flo" -o ${SRCVER} == "android-4.4w_r1" ]; then
	IS_KITKAT=yes
fi
if [ ${IS_ATMEL} == "yes" ]; then
	lunch sama5d3-eng
else
	if [ ${IS_KITKAT} == "yes" ]; then
		if [ ${SRCVER} == "android-hammerhead" ]; then
			lunch aosp_hammerhead-eng
		elif [ ${SRCVER} == "android-flo" ]; then
			lunch aosp_flo-eng
		else
			lunch aosp_arm-eng
		fi
	else
		if [ ${SRCVER} == "android-grouper" ]; then
			lunch full_grouper-eng
		else
			lunch full-eng
		fi
	fi
fi

if [ -f ${BLD_LOG} ]; then 
	echo "${_Br}#"
	echo "# remove old log file ..."
	echo "#${_Tr}"
	rm -rf ${BLD_LOG}
fi

echo "${_Br}#"
echo "# <<<start source build ...>>> "
echo "#${_Tr}"
_TIMEBUILDSTART=$(date +"%s")
make -j4 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

_TIMEMKUBI=0
if [ ${IS_ATMEL} == "yes" ]; then
	echo "${_Br}#"
	echo "# <<<start mkbui image build ...>>> "
	echo "#${_Tr}"
	_TIMEBUILDSTART=$(date +"%s")
	mkubi_image -b sama5d3
	_TIMEBUILDEND=$(date +"%s")
	_TIMEMKUBI=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))
fi

# recovery.img is gen by default, simulator has no recovery.img
#echo "${_Br}#"
#echo "# <<<start recovery img build ...>>> "
#echo "#${_Tr}"
#make -j4 recovery 2>&1 | tee ${BLD_RCV_LOG}

# simulator has no OTA package
echo "${_Br}#"
echo "# <<<start OTA package build ...>>> "
echo "#${_Tr}"
make -j4 otapackage 2>&1 | tee ${BLD_OTA_LOG}

echo "${_Br}#"
echo "# <<<start update package build ...>>> "
echo "#${_Tr}"
make -j4 target-files-package 2>&1 | tee ${BLD_PKG_LOG}

echo "${_Br}#"
echo "# <<<end source build ...>>> "
echo "#${_Tr}"

cd ${ROT_PATH}
echo "${_Br}#"
echo "# current path=`pwd`"
echo "#"
echo "# download time=${_TIMEDOWNLOAD} seconds."
echo "# build    time=${_TIMEBUILD} seconds."
echo "# mkubi    time=${_TIMEMKUBI} seconds."
echo "#${_Tr}"

if [ ! -d ${IMG_PATH} ]; then 
	IMG_PATH=${OUT_PATH}/target/product
fi

echo "${_Br}#"
echo "# img list path=${IMG_PATH}"
echo "#"
ls -l -h -R ${IMG_PATH} | grep "\.img"
echo "#"
ls -l -h -R ${IMG_PATH} | grep "apkcerts-"
ls -l -h -R ${IMG_PATH} | grep "\.zip"
#echo "#"
#ls -l -h -R ${IMG_PATH} | grep "recovery"
echo "#${_Tr}"

