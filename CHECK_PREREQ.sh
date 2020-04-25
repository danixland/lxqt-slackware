#! /bin/bash

# Check prerequisite packages before compile time :-)

CWD=$(pwd)
PREREQ=${PREREQ:-${CWD}/prereq}
PKGS="/var/log/packages"
RESULT="test_prereq.log"
MISSING=0

if [ ! -f $PREREQ ];then
	echo -e "NO LIST OF PREREQUISITE PACKAGES FOUND! EXITING"
	echo "NO PREREQ LIST FOUND!" > $RESULT
	exit 117
else
	# let's source the prereq list
	. $PREREQ
fi

if [ ! -f $RESULT ];then
	touch $RESULT
fi

# let's test them
for KEY in ${!deps[@]}; do
	# echo "KEY is $KEY and VALUE is ${deps[${KEY}]}"
	findings=$(ls $PKGS |egrep -i "^$KEY")
	echo -e "$KEY:" >> $RESULT
	if [[ $findings != "" ]]; then
		for l in $findings; do
			echo -e "Installed\t$l" >> $RESULT
		done
		echo >> $RESULT
	else
		let MISSING=MISSING+1
		echo -e "Missing\t'$KEY'" >> $RESULT
		echo -e "Expected\t'${deps[${KEY}]}'." >> $RESULT
		echo >> $RESULT
	fi
done

if [[ $MISSING -gt 1 ]]; then
	# We have missing packages, issue a warning!!
	echo -e "looks like $MISSING packages are missing. Go check the log."
	echo -e "grep \"Missing\" $RESULT"
	echo
else
	# No missing packages. We can procede!!
	echo -e "GREAT!! All dependancies are satisfied."
	echo -e "Let's start building."
	echo
fi
