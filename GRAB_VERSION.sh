#! /bin/bash

# grab the current tag for each git submodule and store it for later use.

set -e

CWD=$(pwd)
OUTPUT=${CWD}/versioning
WORKDIR=$1

# the versioning file will contain an array that will be pulled by the SlackBuild
cat > $OUTPUT <<ASDFA
#! /bin/bash
#
# Array of LXQT modules and relative version
# This file is sourced during the build process to determine the
# version of every module that is being built.

declare -A versions

versions+=(
ASDFA

cd $WORKDIR
SUBDIRS=$(find . \( ! -regex '.*/\..*' \) -type d -mindepth 1 -maxdepth 1 -print)

for mod in $SUBDIRS; do
	cd $mod
	VERSION=$(git describe --tags)
	MODNAME=$(basename $mod)
	echo -e "\t[\"$MODNAME\"]=\"$VERSION\"" >> $OUTPUT
	# forcing libfm-extra version number because of shared source directory with libfm
	if [[ $MODNAME == "libfm" ]]; then
		echo -e "\t[\"libfm-extra\"]=\"$VERSION\"" >> $OUTPUT
	fi
	cd $WORKDIR
done
echo ")" >> $OUTPUT
echo "" >> $OUTPUT
