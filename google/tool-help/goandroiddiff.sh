#!/bin/sh
#

INPUT=$1

echo "check folder ${INPUT} ... "


A=/home/span/workshop/svn/checkout/n425/android/android-src
B=/home/span/workshop/build/android-4.3_r2/android-src

if [ ! -d ${A}/${INPUT} ]; then
	echo "folder ${INPUT} not found ... "
	exit 0
fi


rm -rf a
rm -rf b

ln -s ${A}/${INPUT} a
ln -s ${B}/${INPUT} b

diff -Naur -x '.git' -x '.svn' a b > ${INPUT}.diff

ls -al



