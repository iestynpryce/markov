CC=gcc
CCP=g++
CCGO=gccgo

OPTS=-Wall -Werror -pedantic
C_OPTS=-std=c11 -D_GNU_SOURCE
CPP_OPTS=-std=c++0x

c/markov:
	${CC} ${OPTS} ${C_OPTS} -o c/markov c/markov.c

cpp/markov:
	${CCP} ${OPTS} ${CPP_OPTS} -o cpp/markov cpp/markov.cpp

go/markov:
	${CCGO} ${OPTS} -o go/markov go/markov.go

all: c/markov cpp/markov go/markov 

test: c/markov cpp/markov go/markov
	cd test && bash run_tests.sh

clean:
	rm -rf c/markov cpp/markov go/markov
