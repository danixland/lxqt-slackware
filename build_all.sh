#!/bin/bash

# Main script, build all packages in the tree.

set -e

CWD=$(pwd)
ERROR_LOG=${CWD}/build_error.log
VERSIONING=${CWD}/versioning

if [ ! -f $VERSIONING ];then
	echo "NO $VERSIONING FOUND! ABORTING NOW." >> $ERROR_LOG
	echo -e "file: $VERSIONING NOT found!! Aborting"
	echo -e "run ${CWD}/GRAB_VERSION.SH to generate the file again."
	exit 118
else
	# We source the versioning file here and use it later
	. $VERSIONING
fi

if [ ! -f $ERROR_LOG ];then
	touch $ERROR_LOG
fi

SLACKBUILD="$CWD/LXQt.SlackBuild"
TMP=${TMP:-/tmp}
BUILD_DIR=${BUILD_DIR:-$TMP/lxqt-build}

check_already_built() {
	local PKG=$1
	RESULT=""
	if [[ -z $(/bin/ls -A ${CWD}/packages) ]];then
		# packages is empty
		RESULT=""
	elif [[ ! $(find ${CWD}/packages/${PKG} -name $PKG* -print > /dev/null 2>&1) ]]; then
		# packages is not empty but we can't find $1
		RESULT=""
	else
		# we found it
		RESULT="found"
	fi
	return $RESULT
}

LIST=$(cat ${CWD}/build_order)
COUNTER=0
TOTAL=$(wc -l ${CWD}/build_order |cut -d " " -f1)
for p in $LIST; do
	let COUNTER=COUNTER+1
	if [[ $p == 'libfm-extra' ]]; then
		# libfm-extra doesn't have a source directory but uses libfm as well
		PKGS=$(find ${CWD}/src -mindepth 1 -maxdepth 1 -type d -name 'libfm' -print)
	else
		PKGS=$(find ${CWD}/src -mindepth 1 -maxdepth 1 -type d -name $p -print)
	fi
	ALREADY_BUILT=$(check_already_built $p)
	VNUM=${versions[${p}]}
	if [[ -e $PKGS && $ALREADY_BUILT != "found" ]];then
		echo -e "########################################################"
		echo -e "#\t[$COUNTER / $TOTAL] building $p"
		echo -e "########################################################"
		export VERSION=$VNUM
		${CWD}/lxqt.SlackBuild $p
		unset VERSION
		echo -e "########################################################"
		echo -e "# done building $p!"
		echo -e "########################################################"
		mkdir -p ${CWD}/packages/${p}
		mv ${BUILD_DIR}/${p}*.txz ${CWD}/packages/${p}/
		upgradepkg --reinstall --install-new ${CWD}/packages/${p}/${p}*.txz
	else
		echo $PKGS not found >> ${ERROR_LOG}
	fi
done

