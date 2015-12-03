#!/bin/sh
#

# 12.04,4.0.4
# 1.
# <command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
# build/core/combo/HOST_linux-x86.mk
# HOST_GLOBAL_CFLAGS += -D_FORTIFY_SOURCE=0
# HOST_GLOBAL_CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0
# 2.
# external/mesa3d/src/glsl/linker.cpp:1394:49: error: expected primary-expression before ‘,’ token 
# vim external/mesa3d/src/glsl/linker.cpp 
# add #include <cstddef> 
# 3.
# external/oprofile/libpp/format_output.h:94:22: error: reference ‘counts’ cannot be declared ‘mutable’ [-fpermissive]
# replace "mutable counts_t & counts;" with "counts_t & counts;"
# 4.
# external/gtest/src/../include/gtest/internal/gtest-param-util.h:122:11: error: ‘ptrdiff_t’ does not name a type 
# external/gtest/src/../include/gtest/internal/gtest-param-util.h
# add #include <cstddef> 
# 5.
# host Executable: test-librsloader (out/host/linux-x86/obj/EXECUTABLES/test-librsloader_intermediates/test-librsloader) 
# vim external/llvm/llvm-host-build.mk 
# add LOCAL_LDLIBS := -lpthread -ldl
# 6.
# frameworks/compile/slang/slang_rs_export_foreach.cpp:249:23: error: variable ‘ParamName’ set but not used [-Werror=unused-but-set-variable]
# vim frameworks/compile/slang/Android.mk
# replace "local_cflags_for_slang := -Wno-sign-promo -Wall -Wno-unused-parameter -Werror" with "local_cflags_for_slang := -Wno-sign-promo -Wall -Wno-unused-parameter"
#

# 12.04,4.2.2
# make: *** [out/host/linux-x86/obj/EXECUTABLES/mkfs.ubifs_intermediates/mkfs.ubifs] Error 1
# “/usr/bin/ld: cannot find -luuid”
# sudo apt-get install uuid-dev:i386
# locate uuid
# sudo apt-get install uuid
# sudo ln -sf /lib/x86_64-linux-gnu/libuuid.so.1.3.0 /lib/x86_64-linux-gnu/libuuid.so
# sudo apt-get install uuid:i386
# sudo ln -sf /lib/i386-linux-gnu/libuuid.so.1.3.0 /lib/i386-linux-gnu/libuuid.so
#

# set if you want image boot from SDMMC
USE_SDMMC=1

ROOT_PATH=`pwd`
SCRIPT_PATH=${ROOT_PATH}/../script
#CCACHE_BIN=${ROOT_PATH}/prebuilts/misc/linux-x86/ccache/ccache
CCACHE_BIN=/usr/bin/ccache
PRODUCT=sabresd_6dq
OUT_BASE=${ROOT_PATH}/../a_out
OUT_PATH=${OUT_BASE}/${PRODUCT}
LOG_NAME=abuild.log
BLD_LOG=${OUT_BASE}/${LOG_NAME}
SET_NAME=abuild.set
BLD_SET=${OUT_BASE}/${SET_NAME}


FREESCALE_FSTAB_PATH=device/fsl/imx6/etc
RECOVERY_FSTAB_PATH=device/fsl/sabresd_6dq
VOLD_FSTAB_PATH=device/fsl/sabresd_6dq
FREESCALE_FSTAB_FILE=fstab.freescale
RECOVERY_FSTAB_FILE=recovery.fstab
VOLD_FSTAB_FILE=vold.fstab
SDMMC_FREESCALE_FSTAB_FILE=${FREESCALE_FSTAB_FILE}.sdmmc.422_110
EMMC_FREESCALE_FSTAB_FILE=${FREESCALE_FSTAB_FILE}.emmc.422_110
SDMMC_RECOVERY_FSTAB_FILE=${RECOVERY_FSTAB_FILE}.sdmmc.422_110
EMMC_RECOVERY_FSTAB_FILE=${RECOVERY_FSTAB_FILE}.emmc.422_110
SDMMC_VOLD_FSTAB_FILE=${VOLD_FSTAB_FILE}.sdmmc.422_110
EMMC_VOLD_FSTAB_FILE=${VOLD_FSTAB_FILE}.emmc.422_110



echo "#" > ${BLD_SET}
echo "#"
echo "# current path=${ROOT_PATH}"
echo "#"
echo "# current path=${ROOT_PATH}" >> ${BLD_SET}

CCACHE_BIN=`find prebuilts/ -name ccache -path "*linux-x86*" -type f`
if [ "${CCACHE_BIN}" == "" ]; then
	CCACHE_BIN=/usr/bin/ccache
fi
if [ -f ${CCACHE_BIN} ]; then
	echo "#"
	echo "# ccache=${CCACHE_BIN}"
	echo "# setup ccache -M 10G ..."
	echo "#"
	export USE_CCACHE=1
	${CCACHE_BIN} -M 10G
fi
echo "# ccache=${CCACHE_BIN}" >> ${BLD_SET}

if [ -d ${OUT_PATH} ]; then 
	echo "#"
	echo "# remove old out folder ..."
	echo "#"
	rm -rf ${OUT_PATH}
fi
mkdir -p ${OUT_PATH}
echo "#"
echo "# set output to ${OUT_PATH} ..."
echo "#"
###export OUT_DIR_COMMON_BASE=${OUT_PATH}
export OUT_DIR=${OUT_PATH}
echo "# output=${OUT_PATH}" >> ${BLD_SET}

echo "#"
echo "# current path=`pwd`"
echo "#"
echo "# setup build env ..."
echo "#"
. build/envsetup.sh

echo "#"
echo "# setup sabresd build with development configuration ..."
echo "#"
#lunch sabresd_6dq-user
#lunch sabresd_6dq-eng

export TARGET_PRODUCT=sabresd_6dq
export TARGET_BUILD_VARIANT=eng
#export TARGET_BUILD_VARIANT=user
export TARGET_BUILD_TYPE=release
echo "# TARGET_PRODUCT=${TARGET_PRODUCT}" >> ${BLD_SET}
echo "# TARGET_BUILD_VARIANT=${TARGET_BUILD_VARIANT}" >> ${BLD_SET}
echo "# TARGET_BUILD_TYPE=${TARGET_BUILD_TYPE}" >> ${BLD_SET}


if [ -f ${BLD_LOG} ]; then 
	echo "#"
	echo "# remove old log file ..."
	echo "#"
	rm -rf ${BLD_LOG}
fi

if [ -f ./buildspec.mk ]; then
	rm ./buildspec.mk
fi 
cp ./build/buildspec.mk.default ./buildspec.mk
cat ${SCRIPT_PATH}/mybuildspec.mk >> ./buildspec.mk
cat ${SCRIPT_PATH}/mybuildspec.mk >> ${BLD_SET}

#JAVA_HOME=/usr/lib/jvm/jdk1.6.0_25
JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
export JAVA_HOME

PATH=$JAVA_HOME/bin:$PATH
export PATH

echo "#"
echo "# PATH=${PATH}"
echo "# JAVA_HOME=${JAVA_HOME}"
echo "#"
echo "# PATH=${PATH}" >> ${BLD_SET}
echo "# JAVA_HOME=${JAVA_HOME}" >> ${BLD_SET}

if [ "${USE_SDMMC}" == "1" ]; then
	FFSTAB=${SCRIPT_PATH}/${SDMMC_FREESCALE_FSTAB_FILE}
	RFSTAB=${SCRIPT_PATH}/${SDMMC_RECOVERY_FSTAB_FILE}
	VFSTAB=${SCRIPT_PATH}/${SDMMC_VOLD_FSTAB_FILE}
else
	FFSTAB=${SCRIPT_PATH}/${EMMC_FREESCALE_FSTAB_FILE}
	RFSTAB=${SCRIPT_PATH}/${EMMC_RECOVERY_FSTAB_FILE}
	VFSTAB=${SCRIPT_PATH}/${EMMC_VOLD_FSTAB_FILE}
fi
echo "#"
echo "# replace freescale fstab file =${FFSTAB}"
echo "# replace recovery fstab file =${RFSTAB}"
echo "# replace vold fstab file =${VFSTAB}"
echo "#"
echo "# replace freescale fstab file =${FFSTAB}" >> ${BLD_SET}
echo "# replace recovery fstab file =${RFSTAB}" >> ${BLD_SET}
echo "# replace vold fstab file =${VFSTAB}" >> ${BLD_SET}
if [ -f ${ROOT_PATH}/${FREESCALE_FSTAB_PATH}/${FREESCALE_FSTAB_FILE} ]; then
	rm -rf ${ROOT_PATH}/${FREESCALE_FSTAB_PATH}/${FREESCALE_FSTAB_FILE}.bak
	mv ${ROOT_PATH}/${FREESCALE_FSTAB_PATH}/${FREESCALE_FSTAB_FILE} ${ROOT_PATH}/${FREESCALE_FSTAB_PATH}/${FREESCALE_FSTAB_FILE}.bak
	cp ${FFSTAB} ${ROOT_PATH}/${FREESCALE_FSTAB_PATH}/${FREESCALE_FSTAB_FILE}
fi
if [ -f ${ROOT_PATH}/${RECOVERY_FSTAB_PATH}/${RECOVERY_FSTAB_FILE} ]; then
	rm -rf ${ROOT_PATH}/${RECOVERY_FSTAB_PATH}/${RECOVERY_FSTAB_FILE}.bak
	mv ${ROOT_PATH}/${RECOVERY_FSTAB_PATH}/${RECOVERY_FSTAB_FILE} ${ROOT_PATH}/${RECOVERY_FSTAB_PATH}/${RECOVERY_FSTAB_FILE}.bak
	cp ${RFSTAB} ${ROOT_PATH}/${RECOVERY_FSTAB_PATH}/${RECOVERY_FSTAB_FILE}
fi
if [ -f ${ROOT_PATH}/${VOLD_FSTAB_PATH}/${VOLD_FSTAB_FILE} ]; then
	rm -rf ${ROOT_PATH}/${VOLD_FSTAB_PATH}/${VOLD_FSTAB_FILE}.bak
	mv ${ROOT_PATH}/${VOLD_FSTAB_PATH}/${VOLD_FSTAB_FILE} ${ROOT_PATH}/${VOLD_FSTAB_PATH}/${VOLD_FSTAB_FILE}.bak
	cp ${VFSTAB} ${ROOT_PATH}/${VOLD_FSTAB_PATH}/${VOLD_FSTAB_FILE}
fi


#make clean
#echo "#"
#echo "# start source build ..."
#echo "#"
#_TIMEBUILDSTART=$(date +"%s")
#make -j8 2>&1 | tee ${BLD_LOG}
#_TIMEBUILDEND=$(date +"%s")
#_TIMEBUILD=$(($_TIMEBUILDEND-$_TIMEBUILDSTART))

cd ${ROOT_PATH}
echo "#"
echo "# current path=`pwd`"
echo "#"
#echo "# build time=${_TIMEBUILD} seconds."
#echo "#"

