#! /bin/bash

CWD=$(pwd)

for line in $(cat ../modules.txt); do
	if [[ ! -f ${CWD}/$line ]]; then
		# we don't have a slack-desc.
		echo "Short description for $line:"
		read desc
		export DESCR="$desc"
		${CWD}/make_slack-desc.sh $line
		unset DESCR
	fi
done

# let's delete all older modules
FILES=$(/bin/ls $CWD)
for f in $FILES; do
	if [ "$(grep -Poc $f ../modules.txt)" -lt 1 ]; then
		if [[ $f != "CHECK_SLACKDESC.sh" && $f != "make_slack-desc.sh" && != "libfm-extra" ]]; then
			rm $f
		fi
	fi	
done
