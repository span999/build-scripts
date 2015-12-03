#!/bin/sh
#

#
# ./tudo.sh; ./tudo.sh N450_EUFCSbranch; ./tudo.sh N435_DVT4branch; 
# ./tudo.sh N435_DVT4branch; ./tudo.sh N435_R19C4; 
#

### tulkas ###
_setWSBranch=tulkas-4AJ.2.5p1
#_setWSBranch=N450_EUFCSbranch
#_setWSBranch=N450_R32G
#_setWSBranch=N450_R32H
#_setWSBranch=N450_R32I
### Aries ###
#_setWSBranch=N483_T35A
##_setWSBranch=N483_R35
##_setWSBranch=N483_R34
### Caddle ###
##_setWSBranch=N485_T03
##_setWSBranch=N485_R03
### Gaia ###
#_setWSBranch=N435_DVT4branch
#_setWSBranch=N435_R19C3
#_setWSBranch=N435_R19C4


if [ -z $1 ]; then
	echo "empty parameter, use default <${_setWSBranch}>"
else
	_setWSBranch=$1
	echo "input parameter with $1, <${_setWSBranch}>"
fi


# Do not modify below ....

_Tr=$(tput sgr0) # Text reset.
_Br=$(tput setab 1) # Red
_TODAY=`date +%Y%m%d%02k%02M%02S`

_setMSGNOTE="<<<<----"
_setHOME=`pwd`
_setUUID=`uuid`
_setIGNORETAG=.ignoreTag
_setIGNOREFILE=${_setHOME}/.ignoreTag
#_setTarVerboseFlag=v
_setTarVerboseFlag=
_setPROJ=tulkas
_setOUTDIR=out
_setRELEASEDIR=release
_setPROJHOME=${_setHOME}/${_setPROJ}_base
_setCPUCORE=`grep -c ^processor /proc/cpuinfo`
_setANDROIDTARBALL=tulkas_base.tar.xz
_setFTPANDROIDTARBALL="ftp://192.168.2.101/Share/android-src/${_setANDROIDTARBALL}"

_setWSPATH=/home/span/workshop/git/tulkas
_setWS_KernelPATH=${_setWSPATH}/kernel.omap
_setWS_ABuildPATH=${_setWSPATH}/build
_setWS_ADevicePATH=${_setWSPATH}/device.ti.tulkas

#if [ ${_setWSBranch} == "N435_DVT4branch" -o [ ${_setWSBranch} == N435* ]]; then
if [[ ${_setWSBranch} == N435* ]]; then
	_setWS_KernelDefconfig=gaia_defconfig
	_setWS_EnvParam1='gaia'
	_setWS_EnvParam2=
else
	_setWS_KernelDefconfig=tulkas_defconfig
	_setWS_EnvParam1='-p tulkas'
	_setWS_EnvParam2=
	#_setWS_EnvParam2='-s aries'
	#_setWS_EnvParam2='-s caddie'
	if [[ ${_setWSBranch} == N450* ]]; then
		_setWS_EnvParam1='tulkas'
		_setWS_EnvParam2=
	fi
	if [[ ${_setWSBranch} == N483* ]]; then
		_setWS_EnvParam1='tulkas'
		_setWS_EnvParam2='aries'
	fi
	if [[ ${_setWSBranch} == N485* ]]; then
		_setWS_EnvParam1='tulkas'
		_setWS_EnvParam2='caddie'
	fi
fi

if [ ${_setWSBranch} == "N435_DVT4branch" -o ${_setWSBranch} == "N450_EUFCSbranch" -o ${_setWSBranch} == "tulkas-4AJ.2.5p1" ]; then
	_setIsBranch=yes	
fi


_logSummaryFile=${_setPROJHOME}/${_TODAY}-summary.log
echo "[${_setUUID}]" > ${_logSummaryFile}
echo "`date`" >> ${_logSummaryFile}
echo ${_setMSGNOTE} >> ${_logSummaryFile}



echo "${_Br}#"
echo ${_setMSGNOTE}
echo "welcome to TUDO peoject ... "
echo ""
echo "UUID=${_setUUID}"
echo "HOME=${_setHOME}"
echo "Project HOME=${_setPROJHOME}"
echo "CPU core = ${_setCPUCORE}"
echo "branch name =${_setWSBranch}"
echo "kernel defconfig=${_setWS_KernelDefconfig}"
echo "#${_Tr}"

echo "UUID=${_setUUID}" >> ${_logSummaryFile}
echo "HOME=${_setHOME}" >> ${_logSummaryFile}
echo "Project HOME=${_setPROJHOME}" >> ${_logSummaryFile}
echo "CPU core = ${_setCPUCORE}" >> ${_logSummaryFile}
echo "branch name =${_setWSBranch}" >> ${_logSummaryFile}
echo "kernel defconfig=${_setWS_KernelDefconfig}" >> ${_logSummaryFile}


### param1=msg to show
_fnShowTitle () {
	_TITLEMSG=$1
	_TITLENOTE='<notice:>'
	echo "${_Br}# # #"
	echo ${_TITLENOTE}
	echo "${_TITLEMSG}"
	echo "# # #${_Tr}"
}

_fnCreateIgnoreTag () {
	_fnShowTitle "preparing ${_setIGNOREFILE} ... "

	if [ -f ${_setIGNOREFILE} ]; then
		rm ${_setIGNOREFILE}
	fi
	echo ".git" > ${_setIGNOREFILE}
	echo ".repo" >> ${_setIGNOREFILE}
	echo ".svn" >> ${_setIGNOREFILE}
}

### param1=log file name, 
### param2=file description
_fnGitLogging () {
	_LOGFILE=$1
	_LOGSCRIPT=$2
	_SEPRATE='------------------------------------------------'
	_NOWPATH=`pwd`
#	echo "fnGitLogging()"
	echo "msg => ${_LOGFILE}"
	echo "msg => ${_LOGSCRIPT}"

	_COMMIT=`git log -1 --format="%H"`
	_BRANCH=`git status | grep "branch " | sed -r 's/^.{12}//'`
	_MESSAGE=`git log -1 --format="%s"`
	_AUTHOR=`git log -1 --format="%cn"`
	_AEMAIL=`git log -1 --format="%ce"`
	_ADATE=`git log -1 --format="%cd"`

	echo "<<<This is log file of ${_LOGSCRIPT}>>>" >> ${_LOGFILE}
	echo ${_SEPRATE} >> ${_LOGFILE}
	echo "local path:${_NOWPATH}" >> ${_LOGFILE}
	echo "branch:${_BRANCH}" >> ${_LOGFILE}
	echo "commit:${_COMMIT}" >> ${_LOGFILE}
	echo "author:${_AUTHOR}" >> ${_LOGFILE}
	echo "email:${_AEMAIL}" >> ${_LOGFILE}
	echo "date:${_ADATE}" >> ${_LOGFILE}
	echo ${_SEPRATE} >> ${_LOGFILE}
	echo "<<<This is the end of ${_LOGSCRIPT}>>>" >> ${_LOGFILE}

#	echo debug msg: now cat out the ${_LOGFILE} file.
#	echo ----------------------------
#	echo ""
#	cat ${_LOGFILE}
#	echo ""
#	echo ----------------------------
}

_fnCreateProjHome () {
	_fnShowTitle "preparing ${_setPROJHOME} ... "

	echo "now @ `pwd`"

	if [ -d ${_setPROJHOME} ]; then
		echo "${_Br}#"
		echo "${_setPROJHOME} aleady exist ..."
		echo "#${_Tr}"
	else
		# check android tar ball
		if [ ! -f ${_setANDROIDTARBALL} ]; then
			wget ${_setFTPANDROIDTARBALL}
		fi
		#mkdir -p ${_setPROJHOME}
		tar xvf ${_setANDROIDTARBALL}
	fi
}

_fnGetKernelSrc () {
	###
	_fnShowTitle "preparing ${_setWS_KernelPATH} ... "
	_logKernelSrcFile=${_setPROJHOME}/${_TODAY}-kernel-source.log

	cd ${_setWS_KernelPATH}
	echo "now @ `pwd`"
	git checkout ${_setWSBranch}
	if [ "yes" == ${_setIsBranch} ]; then
		echo "do a branch update ..."
		git pull
	fi

	echo "[${_setUUID}]" > ${_logKernelSrcFile}
	_fnGitLogging ${_logKernelSrcFile} 'android/kernel source status'

	echo "+ + +" >> ${_logSummaryFile}
	cat ${_logKernelSrcFile} >> ${_logSummaryFile}
	cd -

	###
	_fnShowTitle "preparing ${_setPROJHOME}/kernel ... "
	if [ -d ${_setPROJHOME}/kernel ]; then
		_fnShowTitle "${_setPROJHOME}/kernel aleady exist, kill it ... "
		rm -rf ${_setPROJHOME}/kernel
	else
		echo ""
	fi
	mkdir -p ${_setPROJHOME}/kernel

	cd ${_setWS_KernelPATH}
	echo "now @ `pwd`"
	tar c${_setTarVerboseFlag}f - * --exclude-from=${_setIGNOREFILE} | tar x${_setTarVerboseFlag}f - -C ${_setPROJHOME}/kernel
	#cp .gitignore ${_setPROJHOME}/kernel/
	#cp .mailmap ${_setPROJHOME}/kernel/
	cd -
}

_fnGetAndroidDeviceSrc () {
	###
	_fnShowTitle "preparing ${_setWS_ADevicePATH} ... "
	_logAndroidDeviceSrcFile=${_setPROJHOME}/${_TODAY}-ADevice-source.log

	cd ${_setWS_ADevicePATH}
	echo "now @ `pwd`"
	git checkout ${_setWSBranch}
	if [ "yes" == ${_setIsBranch} ]; then
		echo "do a branch update ..."
		git pull
	fi

	echo "[${_setUUID}]" > ${_logAndroidDeviceSrcFile}
	_fnGitLogging ${_logAndroidDeviceSrcFile} 'android/device source status'

	echo "+ + +" >> ${_logSummaryFile}
	cat ${_logAndroidDeviceSrcFile} >> ${_logSummaryFile}
	cd -

	###
	_fnShowTitle "preparing ${_setPROJHOME}/device/ti/tulkas ... "
	if [ -d ${_setPROJHOME}/device/ti/tulkas ]; then
		_fnShowTitle "${_setPROJHOME}/device/ti/tulkas aleady exist, kill it ..."
		rm -rf ${_setPROJHOME}/device/ti/tulkas
	else
		echo ""
	fi
	mkdir -p ${_setPROJHOME}/device/ti/tulkas

	cd ${_setWS_ADevicePATH}
	echo "now @ `pwd`"
	tar c${_setTarVerboseFlag}f - * --exclude-from=${_setIGNOREFILE} | tar x${_setTarVerboseFlag}f - -C ${_setPROJHOME}/device/ti/tulkas
	#cp .gitignore ${_setPROJHOME}/kernel/
	#cp .mailmap ${_setPROJHOME}/kernel/
	cd -
}

_fnGetAndroidBuildSrc () {
	###
	_fnShowTitle "preparing ${_setWS_ABuildPATH} ... "
	_logAndroidBuildSrcFile=${_setPROJHOME}/${_TODAY}-ABuild-source.log

	cd ${_setWS_ABuildPATH}
	echo "now @ `pwd`"
	git checkout ${_setWSBranch}
	if [ "yes" == ${_setIsBranch} ]; then
		echo "do a branch update ..."
		git pull
	fi

	echo "[${_setUUID}]" > ${_logAndroidBuildSrcFile}
	_fnGitLogging ${_logAndroidBuildSrcFile} 'android/build source status'

	echo "+ + +" >> ${_logSummaryFile}
	cat ${_logAndroidBuildSrcFile} >> ${_logSummaryFile}
	cd -

	###
	_fnShowTitle "preparing ${_setPROJHOME}/device/ti/tulkas/android/build ... "
	if [ -d ${_setPROJHOME}/device/ti/tulkas/android/build ]; then
		_fnShowTitle "${_setPROJHOME}/device/ti/tulkas/android/build aleady exist, kill it ..."
		rm -rf ${_setPROJHOME}/device/ti/tulkas/android/build
	else
		echo ""
	fi
	mkdir -p ${_setPROJHOME}/device/ti/tulkas/android/build

	cd ${_setWS_ABuildPATH}
	echo "now @ `pwd`"
	tar c${_setTarVerboseFlag}f - * --exclude-from=${_setIGNOREFILE} | tar x${_setTarVerboseFlag}f - -C ${_setPROJHOME}/device/ti/tulkas/android/build
	#cp .gitignore ${_setPROJHOME}/kernel/
	#cp .mailmap ${_setPROJHOME}/kernel/
	cd -
}

_fnSyncUpenv_sh () {
	_fnShowTitle "preparing env.sh ... "

	cd ${_setPROJHOME}
	echo "now @ `pwd`"
	if [ -f env.sh ]; then
		rm -rf env.sh
	fi
	ln -s device/ti/tulkas/env.sh env.sh
	cd -
}

_fnBuildEnvPrepare () {
	_fnShowTitle "preparing build environment, ${_setWS_EnvParam1}:${_setWS_EnvParam2} ... "
	echo "+ + +" >> ${_logSummaryFile}
	echo "env use <${_setWS_EnvParam1}:${_setWS_EnvParam2}>" >> ${_logSummaryFile}
	echo "+ + +" >> ${_logSummaryFile}
	export USE_CCACHE=1

	cd ${_setPROJHOME}
	echo "now @ `pwd`"
	. ./env.sh ${_setWS_EnvParam1} ${_setWS_EnvParam2}
	cd -
}

_fnBuildKernel () {
	_fnShowTitle "start build kernel, def=${_setWS_KernelDefconfig} ... "
	_logKernelBuildFile=${_setPROJHOME}/${_TODAY}-Kernel-build.log

	cd ${_setPROJHOME}/kernel
	echo "now @ `pwd`"

	echo "[${_setUUID}]" > ${_logKernelBuildFile}
	echo ${_setMSGNOTE} >> ${_logKernelBuildFile}
	echo "`pwd`" >> ${_logKernelBuildFile}
	echo ${_setMSGNOTE} >> ${_logKernelBuildFile}
	echo "defconfig=${_setWS_KernelDefconfig}" >> ${_logKernelBuildFile}
	echo ${_setMSGNOTE} >> ${_logKernelBuildFile}

	cat ${_logKernelBuildFile} >> ${_logSummaryFile}

	make distclean
	mkel distclean
	mkel ${_setWS_KernelDefconfig}
	mkel -j${_setCPUCORE} 2>&1 | tee -a ${_logKernelBuildFile}
	cd -
}

_fnBuildAndroid () {
	_fnShowTitle "start build android ... "
	_logAndroidBuildFile=${_setPROJHOME}/${_TODAY}-Android-build.log

	cd ${_setPROJHOME}
	echo "now @ `pwd`"
	echo "[${_setUUID}]" > ${_logAndroidBuildFile}
	echo ${_setMSGNOTE} >> ${_logAndroidBuildFile}
	echo "`pwd`" >> ${_logAndroidBuildFile}
	echo ${_setMSGNOTE} >> ${_logAndroidBuildFile}

	cat ${_logAndroidBuildFile} >> ${_logSummaryFile}

	rm -rf ${_setPROJHOME}/${_setOUTDIR}
	make -j${_setCPUCORE} 2>&1 | tee -a ${_logAndroidBuildFile}
	cd -
}

_fnBuildAndroidOTA () {
	_fnShowTitle "start build android OTA package ... "
	_logAndroidOTABuildFile=${_setPROJHOME}/${_TODAY}-AndroidOTA-build.log

	cd ${_setPROJHOME}
	echo "now @ `pwd`"
	echo "[${_setUUID}]" > ${_logAndroidOTABuildFile}
	echo ${_setMSGNOTE} >> ${_logAndroidOTABuildFile}
	echo "`pwd`" >> ${_logAndroidOTABuildFile}
	echo ${_setMSGNOTE} >> ${_logAndroidOTABuildFile}

	cat ${_logAndroidOTABuildFile} >> ${_logSummaryFile}

	make -j${_setCPUCORE} otapackage 2>&1 | tee -a ${_logAndroidOTABuildFile}
	cd -
}

_fnBuildAndroidTFP () {
	_fnShowTitle "start build android update package ... "
	_logAndroidTFPBuildFile=${_setPROJHOME}/${_TODAY}-AndroidTFP-build.log

	cd ${_setPROJHOME}
	echo "now @ `pwd`"
	echo "[${_setUUID}]" > ${_logAndroidTFPBuildFile}
	echo ${_setMSGNOTE} >> ${_logAndroidTFPBuildFile}
	echo "`pwd`" >> ${_logAndroidTFPBuildFile}
	echo ${_setMSGNOTE} >> ${_logAndroidTFPBuildFile}

	cat ${_logAndroidTFPBuildFile} >> ${_logSummaryFile}

	make -j${_setCPUCORE} target-files-package 2>&1 | tee -a ${_logAndroidTFPBuildFile}
	cd -
}


_fnGenBinariesChecksum () {
	_FileList=`ls`
	_UUID=${_setUUID}
	_LogName=img-md5sum.log
	_SeparateLine='--------------------------------------------------'
	_ChecksumBin=${_setPROJHOME}/uboot/checksum


	if [ -f ${_LogName} ]; then
		echo ">>> kill previous log file ..."
		rm -rf ${_LogName}
	fi
	rm -rf *.sum

	echo "[${_UUID}]" > ${_LogName}
	echo ${_SeparateLine} >> ${_LogName}
	echo "use md5sum version : " >> ${_LogName}
	md5sum --version | grep md5sum >> ${_LogName}
	echo ${_SeparateLine} >> ${_LogName}

	for _Item in ${_FileList}
	do
		echo ">>> checking ${_Item} ..."
		echo "md5sum -b ${_Item} :" >> ${_LogName}
		md5sum -b ${_Item} >> ${_LogName}
		md5sum -b ${_Item} > ${_Item}.md5
		${_ChecksumBin} ${_Item} > ${_Item}.sum
	done
}

_fnGenFastbootScript () {
	_setFastbootScrip=doImgFlash.sh

	touch ${_setFastbootScrip}
	echo "#!/bin/sh" >> ${_setFastbootScrip}
	echo "# " >> ${_setFastbootScrip}
	echo "./adb devices" >> ${_setFastbootScrip}
	echo "./adb reboot-bootloader" >> ${_setFastbootScrip}
	echo "./fastboot flash boot img/boot.img" >> ${_setFastbootScrip}
	echo "./fastboot flash system img/system.img" >> ${_setFastbootScrip}
	echo "#./fastboot flash recovery img/recovery.img" >> ${_setFastbootScrip}
	echo "./fastboot erase userdata" >> ${_setFastbootScrip}
	echo "./fastboot erase cache" >> ${_setFastbootScrip}
	echo "./fastboot reboot" >> ${_setFastbootScrip}
	echo "# END" >> ${_setFastbootScrip}
	chmod +x ${_setFastbootScrip}
}

_fnCreateUpdateZip () {
	_fnShowTitle "start create update.zip package ... "

	local _setOutBinPath=${_setPROJHOME}/${_setOUTDIR}/target/product/tulkas
	local _setOutUpdateZip=${_setPROJHOME}/${_setOUTDIR}

	mkdir update_zip_tmp

	cd update_zip_tmp
	echo "now @ `pwd`"
	cp ${_setOutBinPath}/boot.img ./boot.img
	cp ${_setOutBinPath}/recovery.img ./recovery.img
	cp ${_setOutBinPath}/system.img ./system.img
	#cp ${_setOutBinPath}/userdata.img ./userdata.img
	#cp ${_setOutBinPath}/android-info.txt ./android-info.txt
	echo "require board=Ebisu" > android-info.txt
	echo "" >> android-info.txt
	zip -r -9 ${_setOutUpdateZip}/update.zip *
	cd -

	rm -rf update_zip_tmp
}

_fnCopyBinariesImage () {
	echo "${_Br}#"
	echo ${_setMSGNOTE}
	_setReleaseBase=${_setHOME}/${_setRELEASEDIR}
	_setReleaseName=${_setWSBranch}-${_TODAY}
	_setReleasePath=${_setReleaseBase}/${_setReleaseName}
	_setOutBinPath=${_setPROJHOME}/${_setOUTDIR}/target/product/tulkas
	_setOutHostBinPath=${_setPROJHOME}/${_setOUTDIR}/host/linux-x86/bin
	echo "start copy binaries image ... "
	echo "out binary path =${_setOutBinPath}"
	echo "release binary path =${_setReleasePath}"
	echo "#${_Tr}"
	echo ${_setMSGNOTE} >> ${_logSummaryFile}
	echo "out binary path =${_setOutBinPath}" >> ${_logSummaryFile}
	echo "release binary path =${_setReleasePath}" >> ${_logSummaryFile}
	echo ${_setMSGNOTE} >> ${_logSummaryFile}
	echo "branch name =${_setWSBranch} " >> ${_logSummaryFile}
	echo "time source prepare =${_TimeSrcPrepare} seconds." >> ${_logSummaryFile}
	echo "time build kernel =${_TimeKernelBuild} seconds." >> ${_logSummaryFile}
	echo "time build android =${_TimeAndroidBuild} seconds." >> ${_logSummaryFile}
	echo "time build OTA =${_TimeAndroidOTABuild} seconds." >> ${_logSummaryFile}

	cd ${_setPROJHOME}
	_fnGenFastbootScript
	cd -

	cd ${_setPROJHOME}
	echo "now @ `pwd`"
	_setOTAimgZip=`find out/ -name \*target_files-*.zip`
	_setOTAimgTxt=`find out/ -name \*-apkcerts-*.txt`
	mkdir -p ${_setReleasePath}/img
	mkdir -p ${_setReleasePath}/log
	mkdir -p ${_setReleasePath}/tool
	cp ${_setOutBinPath}/boot.img ${_setReleasePath}/img/boot.img
	cp ${_setOutBinPath}/recovery.img ${_setReleasePath}/img/recovery.img
	cp ${_setOutBinPath}/system.img ${_setReleasePath}/img/system.img
	cp ${_setOTAimgZip} ${_setReleasePath}/img/
	cp ${_setOTAimgTxt} ${_setReleasePath}/img/
	mv ${_setPROJHOME}/${_setOUTDIR}/update.zip ${_setReleasePath}/img/update.zip
	cp ${_setOutHostBinPath}/adb ${_setReleasePath}/tool/adb
	cp ${_setOutHostBinPath}/fastboot ${_setReleasePath}/tool/fastboot
	mv ${_setPROJHOME}/doImgFlash.sh ${_setReleasePath}/doImgFlash.sh
	ls -Rhl ${_setReleasePath} >> ${_logSummaryFile}
	echo "" >> ${_logSummaryFile}
	echo "---------------------------------------------------------" >> ${_logSummaryFile}
	echo "export env dump ... " >> ${_logSummaryFile}
	export >> ${_logSummaryFile}
	mv ${_setPROJHOME}/${_TODAY}-* ${_setReleasePath}/log/
	cd -

	cd ${_setReleasePath}
		ln -s tool/adb adb
		ln -s tool/fastboot fastboot
		_setSystemProp=`find ${_setOutBinPath} -name \build.prop`
		cp ${_setSystemProp} ./
	cd -

	cd ${_setReleasePath}/img
	_fnGenBinariesChecksum
	cd -

	cd ${_setReleasePath}/tool
	_fnGenBinariesChecksum
	cd -

	cd ${_setReleaseBase}
	tar Jcvf ${_setReleaseName}.tar.xz ${_setReleaseName}
	md5sum -b ${_setReleaseName}.tar.xz > ${_setReleaseName}.tar.xz.md5
	cd -

	echo "${_Br}#"
	echo ${_setMSGNOTE}
	ls -Rhl ${_setReleasePath}
	echo "#${_Tr}"

}



_fnCreateIgnoreTag

_fnCreateProjHome

_TimeBuildStart=$(date +"%s")
_fnGetKernelSrc

_fnGetAndroidDeviceSrc

_fnGetAndroidBuildSrc
_TimeBuildEnd=$(date +"%s")
_TimeSrcPrepare=$(($_TimeBuildEnd-$_TimeBuildStart))

_fnSyncUpenv_sh

_fnBuildEnvPrepare

_TimeBuildStart=$(date +"%s")
_fnBuildKernel
_TimeBuildEnd=$(date +"%s")
_TimeKernelBuild=$(($_TimeBuildEnd-$_TimeBuildStart))


_TimeBuildStart=$(date +"%s")
_fnBuildAndroid
_TimeBuildEnd=$(date +"%s")
_TimeAndroidBuild=$(($_TimeBuildEnd-$_TimeBuildStart))

_TimeBuildStart=$(date +"%s")
_fnBuildAndroidOTA
##_fnBuildAndroidTFP
_TimeBuildEnd=$(date +"%s")
_TimeAndroidOTABuild=$(($_TimeBuildEnd-$_TimeBuildStart))

_fnCreateUpdateZip

_fnCopyBinariesImage

echo "${_Br}#"
echo ${_setMSGNOTE}
echo ${_setMSGNOTE}
echo "branch name =${_setWSBranch} "
echo "time source prepare =${_TimeSrcPrepare} seconds."
echo "time build kernel =${_TimeKernelBuild} seconds."
echo "time build android =${_TimeAndroidBuild} seconds."
echo "time build OTA =${_TimeAndroidOTABuild} seconds."
echo "#${_Tr}"

exit 0
