# Event 1: Pairing Off
# Given a series of five playing cards, determine the number of pairs.
use v6;

my @x = 6,5,6,6,"K";

say 'Total: ' ~ (([+] @x XeqX @x) - @x.elems)/2; 
