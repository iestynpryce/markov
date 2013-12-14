// Markov public interface
// From Pike and Kernighan's 'The Practice of Programming'

import markov.Chain;
import java.io.IOException;

class Markov {
	static final int MAXGEN = 10000; // maximum words generated
	public static void main(String[] args) throws IOException
	{
		Chain chain = new Chain();
		int nwords = MAXGEN;

		chain.build(System.in);
		chain.generate(nwords);
	}
}
