// Chain: reads input, builds the hash table and generates output
// From Pike and Kernighan's 'The Practice of Programming'
package markov;

import markov.Prefix;

import java.util.Vector;
import java.util.Random;
import java.io.StreamTokenizer;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.Reader;
import java.util.Hashtable;
import java.util.Enumeration;

public class Chain {
	static final int NPREF = 2; // size of prefix
	static final String NONWORD = "\n"; // word that can't appear
	Hashtable<Prefix, Vector<String> > statetab = new Hashtable<Prefix, Vector<String> >();
				// key = Prefix, value = suffix Vector
	Prefix prefix = new Prefix(NPREF, NONWORD); // initial prefix
	Random rand = new Random();

	// Chain build: build State table from input stream
	public void build(InputStream in) throws IOException
	{

		Reader r = new BufferedReader(new InputStreamReader(in));
		StreamTokenizer st = new StreamTokenizer(r);

		st.resetSyntax(); 	// remove default values
		st.wordChars(0, Character.MAX_VALUE);  	// turn on all chars
		st.whitespaceChars(0, ' '); 		// except up to blank
		while (st.nextToken() != st.TT_EOF)
		{
			add(st.sval);
		}
		add(NONWORD);
	}

	// Chain add: add word to suffix list, update prefix
	void add(String word)
	{
		Vector<String> suf = (Vector<String>) statetab.get(prefix);
		if (suf == null) {
			suf = new Vector<String>();
			statetab.put(new Prefix(prefix), suf);
		}
		suf.addElement(word);
		prefix.pref.removeElementAt(0);
		prefix.pref.addElement(word);
	}	

	// Chain generate: generet output words
	public void generate(int nwords)
	{
		prefix = new Prefix(NPREF, NONWORD);
		for (int i=0; i < nwords; i++)
		{
			Vector<String> s = (Vector<String>) statetab.get(prefix);
			if ( s == null) System.out.println("s is null");
			int r = Math.abs(rand.nextInt()) % s.size();
			String suf = (String) s.elementAt(r);
			if (suf.equals(NONWORD)) break;
			System.out.println(suf);
			prefix.pref.removeElementAt(0);
			prefix.pref.addElement(suf);
		}
	}
}
