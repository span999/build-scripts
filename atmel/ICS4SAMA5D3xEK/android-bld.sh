#!/bin/sh
#


_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red

ROT_PATH=`pwd`
SRC_BASE=/home/span/workshop/git/android/atmel/android4sam/android/android4sam_v4.1
BLD_LINK=android-src
BLD_BASE=${ROT_PATH}/${BLD_LINK}
_REPOROOT=https://n425.cee.mitac.com/svn/n425
_SVNREPO=${_REPOROOT}/branches/user/span/android
#_SVNPROJ=android4sam_v4.0
_SVNPROJ=android4sam_v4.1
_SVNWS=/home/span/workshop/svn/checkout/n425/android/android-src



REL_BASE=${ROT_PATH}
OUT_PATH=${REL_BASE}/aout
LOG_NAME=abuild.log
BLD_LOG=${ROT_PATH}/${LOG_NAME}

_TIMEBUILDSTART=
_TIMEBUILDEND=
_TIMEBUILD=


echo "${_Br}#"
echo "# current path=`pwd`"
echo "#${_Tr}"
# use Git,,,
#if [ -L ${BLD_LINK} ]; then
#	rm -rf ${BLD_LINK}
#fi
#ln -s ${SRC_BASE} ${BLD_LINK}
# use Subversion,,,
echo "${_Br}# "
echo "# get the source"
echo "# ${_Tr}" 
if [ -d ${BLD_LINK} ]; then
	rm -rf ${BLD_LINK}
	echo "${_Br}# "
	echo "# remove old folder first ..."
	echo "# ${_Tr}" 
fi

echo "${_Br}# "
echo "# repo=${_SVNREPO}/${_SVNPROJ}"
echo "# workspace=${_SVNWS}"
echo "# ${_Tr}"
if [ ! -d ${_SVNWS} ]; then
	svn co ${_SVNREPO}/${_SVNPROJ} ${_SVNWS} 
fi
svn sw ${_SVNREPO}/${_SVNPROJ} ${_SVNWS}
svn export ${_SVNWS} ${BLD_LINK}


CCACHE_BIN=`find ${BLD_LINK}/prebuilts/ -name ccache -path "*linux-x86*" -type f`
if [ ${CCACHE_BIN} == "" ]; then
	CCACHE_BIN=/usr/bin/ccache
fi
if [ -f ${CCACHE_BIN} ]; then
	echo "${_Br}#"
	echo "# ${CCACHE_BIN}"
	echo "# setup ccatch -M 10G ..."
	echo "#${_Tr}"
	export USE_CCACHE=1
	${CCACHE_BIN} -M 10G
fi

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

export JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
echo "${_Br}#"
echo "# JAVA_HOME=${JAVA_HOME}"
echo "#${_Tr}"


cd ${BLD_LINK}
echo "${_Br}#"
echo "# current path=`pwd`"
echo "# "
echo "# setup build env ..."
echo "#${_Tr}"
. build/envsetup.sh

echo "${_Br}#"
echo "# setup emulator build with development configuration ..."
echo "#${_Tr}"
lunch sama5d3-eng

if [ -f ${BLD_LOG} ]; then 
	echo "${_Br}#"
	echo "# remove old log file ..."
	echo "#${_Tr}"
	rm -rf ${BLD_LOG}
fi

echo "${_Br}#"
echo "# start source build ..."
echo "#${_Tr}"
_TIMEBUILDSTART=$(date +"%s")
make -j4 2>&1 | tee ${BLD_LOG}
_TIMEBUILDEND=$(date +"%s")
_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

cd ${ROT_PATH}
echo "${_Br}#"
echo "# current path=`pwd`"
echo "#"
echo "# build time=${_TIMEBUILD} seconds."
echo "#${_Tr}"

