#!/usr/bin/env perl
# From 'Practice of Programming' by Pike and Kernighan, fixed for strictness
# markov.l: markov char algorithm for 2-word prefixes

use warnings;
use strict;

my $MAXGEN = 10000;
my $NONWORD = "\n";
my ($w1, $w2);

my %statetab;

$w1 = $w2 = $NONWORD;   # initial state
while (<>)
{
    my $i = 0;
    foreach (split) {
        push(@{$statetab{$w1}{$w2}}, $_);
        ($w1, $w2) = ($w2, $_); # multiple assignment
    }
}
push(@{$statetab{$w1}{$w2}}, $NONWORD);    # add tail;

$w1 = $w2 = $NONWORD;
for(my $i = 0; $i < $MAXGEN; $i++)
{
    my $suf = $statetab{$w1}{$w2}; # array reference
    my $r = int(rand @$suf );      # @$suf is number of elems
    exit if ((my $t = $suf->[$r]) eq $NONWORD);
    print "$t\n";
    ($w1, $w2) = ($w2, $t);        # advance chain
}
