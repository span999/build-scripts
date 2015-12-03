#!/bin/sh
#


# u-boot parameter
# U-Boot > setenv fastboot_dev
# U-Boot > setenv bootcmd booti mmc2
# U-Boot > setenv bootargs console=ttymxc0,115200 init=/init video=mxcfb0:dev=ldb,bpp=32 video=mxcfb1:off video=mxcfb2:off fbmem=10M fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc0 androidboot.hardware=freescale
# U-Boot > setenv bootargs console=ttymxc0,115200 init=/init video=mxcfb0:dev=lcd,SEIKO-WVGA,if=RGB24 video=mxcfb1:off video=mxcfb2:off fbmem=10M fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc0 androidboot.hardware=freescale
# U-Boot > setenv bootargs console=ttymxc0,115200 init=/init video=mxcfb0:dev=ldb,LDB_XGA,if=RGB666,bpp=24 video=mxcfb0:dev=lcd,SEIKO-WVGA,if=RGB24 video=mxcfb1:off video=mxcfb2:off fbmem=10M fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc0 androidboot.hardware=freescale
# U-Boot > saveenv
# 


ROOT_PATH=`pwd`
SCRIPT_PATH=${ROOT_PATH}/../script
PRODUCT=sabresd_6dq
OUT_BASE=${ROOT_PATH}/../a_out
OUT_PATH=${OUT_BASE}/${PRODUCT}/target/product/${PRODUCT}
LOG_NAME=aImage.log
BLD_LOG=${OUT_BASE}/${LOG_NAME}


echo "#"
echo "# current path=${ROOT_PATH}"WW
echo "#"
echo "# current path=${ROOT_PATH}" > ${BLD_LOG}

rm -rf *

#cp ${OUT_PATH}/u-boot.bin ./
cp ${OUT_PATH}/u-boot-6q.bin ./u-boot.bin
cp ${OUT_PATH}/boot.img ./
cp ${OUT_PATH}/recovery.img ./
cp ${OUT_PATH}/system.img ./

