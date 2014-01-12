#!/bin/bash
# Run all tests against all programs

progs=( ../c/markov 
        ../cpp/markov 
        'java -cp ../java/ Markov'
	../go/markov
        ../awk/markov.awk
	../perl/markov.pl
	../python/markov.py )

alice="../text/gutenberg_alice_in_wonderland.txt"

for p in "${progs[@]}"; do
	echo "Testing $p"
	bash test_edge_cases.sh "$p"
	$p < "$alice" > "alice.out"
	awk -f test_word_groups.awk "$alice" "alice.out"
	rm "alice.out"
	bash test_statistics.sh "$p"
done
