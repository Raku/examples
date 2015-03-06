# Event 1: Pairing Off
# Given a series of five playing cards, determine the number of pairs.
use v6;

my @x = 6,5,6,6,"K";

say 'Total: ' ~ (([+] @x Xeq @x) - @x.elems)/2;

# vim: expandtab shiftwidth=4 ft=perl6
