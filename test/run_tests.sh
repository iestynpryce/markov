#!/bin/bash
# Run all tests against all programs

progs=( ../c/markov 
        ../cpp/markov 
        'java -cp ../java/ Markov'
	../go/markov
        ../awk/markov.awk
	../perl/markov.pl
	../python/markov.py )

for p in "${progs[@]}"; do
	echo "Testing $p"
	bash test_edge_cases.sh "$p"
done
