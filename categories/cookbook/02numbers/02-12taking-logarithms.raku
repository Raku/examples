#!/usr/bin/env raku

use v6;

=begin pod

=TITLE Logarithms

=AUTHOR uzluisf

You want to take logarithms in several bases.

=end pod

=comment For logarithms to base 10

put log10 100; #=> 2
put 250.log10; #=> 2.397940008672037

=comment For logarithms to any base (or base e by default)

put log e³;      #=> 3
put log 6561, 9; #=> 4
put 1024.log(2); #=> 10

# vim: expandtab shiftwidth=4 ft=perl6
