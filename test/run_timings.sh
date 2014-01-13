#!/bin/bash
# Run a timing test against each of the programs

source test_common.sh

# number of tests to run
N=10000

# Set input and output files
TIMELOG="timings.out"
AVGOUT="timeavg.out"

# Reset output file
>|$AVGOUT

for p in "${progs[@]}"; do
	echo "timing $p..."
	# Reset timelog
	>|$TIMELOG
	for ((i=0; i<$N; i++)); do
		/usr/bin/time -a -o $TIMELOG -p $p < "$alice" > /dev/null
	done
	echo -n "${p}	" >>$AVGOUT
	awk '(/^real/) { time+=$2; n++ }
		END { print time/n }' < "$TIMELOG" >> $AVGOUT
	rm "$TIMELOG"
done
