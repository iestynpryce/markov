CC=gcc
CCP=g++
CCGO=gccgo
CCRUST=cargo

OPTS=-Wall -Werror -pedantic
C_OPTS=-std=c11 -D_GNU_SOURCE
CPP_OPTS=-std=c++0x

all: c/markov cpp/markov go/markov c/markov

c/markov:
	${CC} ${OPTS} ${C_OPTS} -o c/markov c/markov.c

cpp/markov:
	${CCP} ${OPTS} ${CPP_OPTS} -o cpp/markov cpp/markov.cpp

go/markov:
	${CCGO} ${OPTS} -o go/markov go/markov.go

rust/markov:
	cd rust; ${CCRUST} build --release


test: c/markov cpp/markov go/markov rust/markov
	cd test && bash run_tests.sh

clean:
	rm -rf c/markov cpp/markov go/markov
	cd rust; ${CCRUST} clean
