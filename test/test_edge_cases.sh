#!/bin/bash
# Tests program defined on the command line with 5 files ranging from
# 0 to 4 words. Output should be identical to the input.

if [ $# -lt 1 ]; then
	echo "usage: $0 program" > /dev/stderr
	exit -1
fi

PROG="$1"

FILES=( blank.txt a.txt ab.txt abc.txt abcd.txt )

for f in ${FILES[@]}; do
	out=${f%.txt}.out
	$PROG < $f > $out
	diff -q $f $out
        if [ "$?" -ne "0" ]; then
		echo "$PROG failed on $f";
		exit -1
	fi
	rm $out	
done

