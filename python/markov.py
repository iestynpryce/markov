#!/usr/bin/env python

import sys
import random

npref=2         # number of prefixes to use
maxgen=10000    # maximum output size
nonword='\n'    # delimiter

statetab = {}   # dictionary of all npref word prefixes to possible suffixes

# tokenize: tokenize data in file descriptor into words
def tokenize(f):
    for line in f:
        for word in  line.split():
            yield word

# add_suffix: adds suffix word to statetab dictionry for key 'prefix'
def add_suffix(prefix, word):
    k = nonword.join(prefix)
    suf = []
    if statetab.has_key(k):
        suf = statetab[k]
    suf.append(word)
    statetab[k] = suf

# build: create prefix to suffix mappings
def build(f):
    words = tokenize(f)
    pref = []
    for i in range(0, npref):
        pref.append(nonword)
    for w in words:
        add_suffix(pref,w)
        pref.append(w)
        del pref[0]

    add_suffix(pref,nonword) # mark end of input

# generate: create markov model based output
def generate(maxn):
    pref = []
    for i in range(0, npref):
        pref.append(nonword)

    for i in range(0, maxn):
        suf_list = statetab[nonword.join(pref)]
        suffix = suf_list[random.randrange(len(suf_list))]
        if suffix == nonword:
            break

        print suffix
        pref.append(suffix)
        del pref[0]

def main():
    build(sys.stdin)
    generate(maxgen)

if __name__ == "__main__":
    main()
