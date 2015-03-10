use v6;

=begin pod

=TITLE Pairing Off

=AUTHOR David Romano

Given a series of five playing cards, determine the number of pairs.

=end pod

my @x = 6,5,6,6,"K";

say 'Total: ' ~ (([+] @x Xeq @x) - @x.elems)/2;

# vim: expandtab shiftwidth=4 ft=perl6
