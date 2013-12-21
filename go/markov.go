// markov.go: implementation of Markov chain text generation in Go
// Based on ideas in 'The Practice of Programming' by Pike and Kernighan

package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"math/rand"
)

const (
	npref 		= 2 	// The number of prefixes
	maxgen 		= 10000 // The maximum generated words
	nonword		= "\n" 	// Special terminating character
)

type Prefix struct {
	p1 string
	p2 string
}

func (p *Prefix) add(newpref string) {
	p.p1 = p.p2
	p.p2 = newpref
}

type Suffix []string

var statemap = make(map[Prefix]Suffix)

func main() {
	build(os.Stdin)
	generate()
}

// build: read input, build prefix map
func build(file *os.File) {
	// Initialize prefix
	pref := Prefix{p1: nonword, p2: nonword}

	// Open file for reading and tokenize
	contents, err := ioutil.ReadAll(file)
	if err != nil { panic(err) }
	s := strings.Fields(string(contents))

	// Loop over input
	for i,_ := range s {
		add(pref,s[i])
		pref.add(s[i])		
	}
	add(pref,nonword) // add end of text guard
}

// generate: produce output one word per line
func generate() {
	pref := Prefix{p1: nonword, p2: nonword}
	for i := 0; i < maxgen; i++ {
		suflist := statemap[pref]
		suf := suflist[rand.Intn(len(suflist))]
		if suf == nonword {
			break
		}
		fmt.Printf("%s\n",suf)
		pref.add(suf)
	}	
}

// add: add word to suffix list, update prefix
func add(pref Prefix, word string) {
	var suf []string
	if suffix, ok := statemap[pref]; ok {
		suf = suffix
	}
	statemap[pref]=append(suf,word)
}
