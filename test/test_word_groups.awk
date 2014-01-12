#!/usr/bin/awk -f
# markov test: check that all words, pairs, triples in 
#    ouput ARGV[2] are in the original input ARGV[1]
# from K&P's The Practice of Programming
BEGIN {
    while (getline <ARGV[1] > 0)
        for (i = 1; i <= NF+1; i++) {
            wd[++nw] = $i   # input words
#    print "adding word", $i
            single[$i]++
#	    if (!(($i in single)))
#	    	print $i, "not found in single[]"
        }
    for (i = 1; i < nw; i++)
        pair[wd[i],wd[i+1]]++
    for (i = 1; i < nw-1; i++)
        triple[wd[i],wd[i+1],wd[i+2]]++

    while (getline <ARGV[2] > 0) {
        outwd[++ow] = $0    # output words
        if (!($0 in single))
            print "unexpected word", $0
    }
#    for (i = 1; i < ow; i++)
#        if (!((outwd[i],outwd[i+1]) in pair))
#             print "unexpected pair", outwd[i], outwd[i+1]
#    for (i = 1; i < ow-1; i++)
#        if (!((outwd[i],outwd[i+1],outwd[i+2]) in triple))
#             print "unexpected triple",
#                    outwd[i], outwd[i+1], outwd[i+2]
}
