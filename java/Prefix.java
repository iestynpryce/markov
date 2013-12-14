// Prefix: holds the words of prefixes
// From Pike and Kernighan's 'The Practice of Programming'

package markov;

import java.util.Vector;
import java.util.Hashtable;
import java.lang.String;

public class Prefix {
		public Vector<String> pref; // NPREF adjacent words from input

		static final int MULTIPLIER = 31; // for hsahCode()

		// Prefix constructor: duplicate existing prefix
        public Prefix(Prefix p)
		{
				pref = (Vector<String>) p.pref.clone();
		}

		// Prefix constructor: n copies of str
		public Prefix(int n, String str)
		{
				pref = new Vector<String>();
				for (int i=0; i < n; i++)
				{
						pref.addElement(str);
				}
		}
		
		// Prefix hashCode: generate hash from all prefix words
		@Override
		public int hashCode()
		{
			int h = 0;
			for (int i = 0; i < pref.size(); i++)
			{
				h = MULTIPLIER * h + pref.elementAt(i).hashCode();
			}
			return h;
		}

		// Prefix equals: compare two prefixes for equal words
		@Override
		public boolean equals(Object o)
		{
				Prefix p = (Prefix) o;
				for (int i = 0; i < pref.size(); i++)
				{
						if (!pref.elementAt(i).equals(p.pref.elementAt(i)))
								return false;
				}
				return true;
		}
}
