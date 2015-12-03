#!/bin/sh
#

INPUT=$1

echo "patch folder ${INPUT} ... "
ROOT=`pwd`

A=/home/span/workshop/svn/checkout/n425/android/android-src
B=/home/span/workshop/build/android-4.3_r2/android-src

if [ ! -d ${A}/${INPUT} ]; then
	echo "folder ${INPUT} not found ... "
	exit 0
fi


if [ ! -f ./${INPUT}.diff ]; then
	echo "file ${INPUT}.diff not found ... "
	exit 0
fi

rm -rf a
#rm -rf b

ln -s ${A}/${INPUT} a
#ln -s ${B}/${INPUT} b

cd a
#diff -Naur -x '.git' -x '.svn' a b > ${INPUT}.diff
patch -p1 < ${ROOT}/${INPUT}.diff
cd -

ls -al



