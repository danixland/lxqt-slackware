#! /bin/bash

# Download the superproject and all submodules for LXQT
# LXQT VERSION 0.15.0

set -e

CWD=$(pwd)
LXQT="https://github.com/lxqt/lxqt.git"
SRCDIR=${SRCDIR:-$CWD/src}
ERROR_LOG=${CWD}/build_error.log
GIT=${GIT:-/usr/bin/git}

if [ ! -f $ERROR_LOG ];then
	touch $ERROR_LOG
fi

# clone the superproject in the source directory
$GIT clone $LXQT $SRCDIR || echo "error cloning superproject" >> $ERROR_LOG
cd $SRCDIR

# initialize every submodule
$GIT submodule init || echo "error initializing submodules" >> $ERROR_LOG

# checkout every submodule
$GIT submodule update --remote --rebase || echo "error during checkout of submodules" >> $ERROR_LOG

# we grab the module's version numbers before deleting everything git related
sh ${CWD}/GRAB_VERSION.sh $SRCDIR

# we are done with git, so let's cleanup from all the unwanted git folders and files
find . -name '.git*' -mindepth 1 -exec rm -rfv '{}' \; || echo "error during removal of git files from source" >> $ERROR_LOG

# ALL DONE
