#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Upper/Lower Case

=AUTHOR stmuk

You have a string and want to upper/lower case it

=end pod

my $string = "the cat sat on the mat";

say $string=$string.uc; # THE CAT SAT ON THE MAT

say $string.=lc;        # the cat sat on the mat

say $string.wordcase;   # The Cat Sat On The Mat

$string.tc.say;         # The cat sat on the mat

# vim: expandtab shiftwidth=4 ft=perl6
