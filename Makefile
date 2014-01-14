CC=gcc
CCP=g++
CCGO=gccgo

c/markov:
	${CC} -o c/markov c/markov.c

cpp/markov:
	${CCP} -o cpp/markov cpp/markov.cpp

go/markov:
	${CCGO} -o go/markov go/markov.go

all: c/markov cpp/markov go/markov 

test: c/markov cpp/markov go/markov
	cd test && bash run_tests.sh

clean:
	rm -rf c/markov cpp/markov go/markov
