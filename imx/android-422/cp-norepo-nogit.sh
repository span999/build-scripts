#!/bin/sh
#

SRC=$1
TAR=$2

if [ -d ${SRC} ]; then
	echo -n "copy from ${SRC} "
	if [ -d ${TAR} ]; then
		echo "to ${TAR}"
	else
		mkdir -p ${TAR}
		echo "to ${TAR}"
	fi

	tar -c ${SRC} --exclude=.repo --exclude=.git | tar -x -C ${TAR}
else
	echo "source folder not found ...."
fi

