#!/bin/bash
# Run all tests against all programs

source test_common.sh

for p in "${progs[@]}"; do
	echo "Testing $p"
	bash test_edge_cases.sh "$p"
	$p < "$alice" > "alice.out"
	awk -f test_word_groups.awk "$alice" "alice.out"
	rm "alice.out"
	bash test_statistics.sh "$p"
done
