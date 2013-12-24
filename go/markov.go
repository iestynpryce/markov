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

type Prefix []string
func (p *Prefix) add(newpref string) {
	*p = append(*p, newpref)  // add newest prefix word
	*p = (*p)[1:] 		// remove oldest prefx
}

type Suffix []string

var statemap = make(map[string]Suffix)

func main() {
	build(os.Stdin)
	generate()
}

// build: read input, build prefix map
func build(file *os.File) {
	// Initialize prefix
	var pref Prefix
	for i := 0; i < npref; i++ {
		pref = append(pref, nonword)
	} 

	// Open file for reading and tokenize
	contents, err := ioutil.ReadAll(file)
	if err != nil { panic(err) }
	s := strings.Fields(string(contents))

	// Loop over input
	for i := range s {
		add(pref,s[i])
		pref.add(s[i])		
	}
	add(pref,nonword) // add end of text guard
}

// generate: produce output one word per line
func generate() {
	var pref Prefix
	for i := 0; i < npref; i++ {
		pref = append(pref, nonword)
	}
	for i := 0; i < maxgen; i++ {
		suflist := statemap[strings.Join(pref,nonword)]
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
	key := strings.Join(pref,nonword)
	if suffix, ok := statemap[key]; ok {
		suf = suffix
	}
	statemap[key]=append(suf,word)
}
