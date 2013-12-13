// markov.cpp from 'The Practice of Programming' by Pike and Kernighan

#include <iostream>
#include <fstream>
#include <deque>
#include <map>
#include <vector>
#include <cstdlib>

using namespace std;

typedef deque<string> Prefix;
map<Prefix, vector<string> > statetab; // prefix -> suffixes
enum {
    NPREF   = 2,    /* number of prefix words */
    NHASH   = 4093, /* size of state hash table array */
    MAXGEN  = 10000 /* maximum words generated */
};

const string NONWORD = "\n";

void build(Prefix& prefix, istream& in);
void add(Prefix& prefix, const string& s);
void generate(int nwords);

// markov main: markov-chain random text generation
int main(void)
{
  int nwords = MAXGEN;
  Prefix prefix;	  // current input prefix

  for (int i = 0; i < NPREF; i++) // set up initial prefix
  {
      add(prefix, NONWORD);
  }

  build(prefix, cin);
  add(prefix, NONWORD);
  generate(nwords);
  return 0;
}

// build: read input worlds, build state table
void build(Prefix& prefix, istream& in)
{
  string buf;

  while (in >> buf)
  {
      add(prefix, buf);
  }
}

// add: add word to suffix list, update prefix
void add(Prefix& prefix, const string& s)
{
  if (prefix.size() == NPREF)
  {
      statetab[prefix].push_back(s);
      prefix.pop_front();
  }
  prefix.push_back(s);
}

// generate: produce output, one word per line
void generate(int nwords)
{
  Prefix prefix;
  int i;

  for (i = 0; i < NPREF; i++) // reset initial prefix
  {
      add(prefix, NONWORD);
  }
  for (i = 0; i < nwords; i++)
  {
      vector<string>& suf = statetab[prefix];
      const string& w = suf[rand() % suf.size()];
      if (w == NONWORD)
      {
	  break;
      }
      cout << w << "\n";
      prefix.pop_front(); // advance
      prefix.push_back(w);
  }
}
