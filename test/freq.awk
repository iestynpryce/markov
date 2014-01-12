#!/usr/bin/awk -f
# word frequency counter
{
	for (i=1; i<=NF; i++)
		wd[$i]++
}
END {
	for ( word in wd )
	{
		printf("%s\t%d\n", word, wd[word])
	}
}
