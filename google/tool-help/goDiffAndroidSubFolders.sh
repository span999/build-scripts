#!/bin/sh
#
#

# for 4.3_r2.1
# ignore prebuilts
# check frameworks,packages,prebuilts manual
#_DirList='abi bionic bootable build cts dalvik developers development device docs external frameworks hardware libcore libnativehelper ndk packages pdk sdk system tools Makefile'
#_androidVer=android-4.3_r2.1

# for 4.4.2_r1
# ignore art prebuilts
# check external,frameworks,packages,prebuilts manual
_DirList='abi bionic bootable build cts dalvik developers development device docs external frameworks hardware libcore libnativehelper ndk packages pdk sdk system tools Makefile'
_androidVer=android-4.4.2_r1

_diR=123
_froMPath=../android-src
_tOPath=/home/span/workshop/git/googlesource/${_androidVer}

echo "${_DirList}"

if [ -d ${_androidVer} ]; then
	rm -rf ${_androidVer}
fi
mkdir ${_androidVer}


for _diR in ${_DirList}
do
	echo "now checking ${_diR} ..."
	rm -rf a
	rm -rf b
#	rm -rf ${_androidVer}/${_diR}.diff
	ln -s ${_froMPath}/${_diR} a
	ln -s ${_tOPath}/${_diR} b
	diff -Naur --exclude-from=sh_ignoreFILEs a b > ${_androidVer}/${_diR}.diff
done
