#!/bin/sh
#

_COMMITMSG="[SP] check-in android-4.4.2_r1 source."
_DIR1=`ls`
_DIR2=`ls`

for _SUB1 in ${_DIR1}
do
	echo "checking ${_SUB1} ... "
	_DIR2=`ls ${_SUB1}`
	for _SUB2 in ${_DIR2}
	do
		echo "checking ${_SUB1}/${_SUB2} ... "
		svn status ${_SUB1}/${_SUB2}
	done
done

