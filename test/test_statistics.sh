#!/bin/bash
# Test the output statistics of the programs
# Do this by making a file with N times "a b c" and 2N times "a b d"
# - the output should have around twice as many 'd's as 'c's.

set -e

PROG="${1}" # Program to test

INPUT="test_stats.in"
OUTPUT="test_stats.out"

N=10000 # Number of times 'a b c' will appear in test

# Set default return value to 1
RETURN=1

# Test that $d_num is roughly double of $c_num
is_roughly_double() {
	let ten_pct=$c_num/5
	let double_c=$c_num*2
	let lower=$d_num-$ten_pct
	let upper=$d_num+$ten_pct

	if (( $lower <= $double_c && $double_c <= $upper)); then 
		RETURN=0;
	else
		echo "$0 failed test for $PROG" > /dev/stderr
		echo "2*$c_num !~ $d_num" > /dev/stderr
		exit $RETURN
	fi
}

# Make the test input file
>"$INPUT"
for i in $(seq 1 $N); do
	echo "a b c" >> "$INPUT"
	echo "a b d" >> "$INPUT"
	echo "a b d" >> "$INPUT"
done

# Get the output
$PROG < "$INPUT" > "$OUTPUT"

# Get numbers of 'c's and 'd's
stats=$(awk -f freq.awk < "$OUTPUT" | grep '^[c\|d]')
c_num=$(echo "$stats" | awk '/c/{ print $2 }')
d_num=$(echo "$stats" | awk '/d/{ print $2 }')

is_roughly_double

rm "$INPUT" "$OUTPUT"

exit $RETURN
