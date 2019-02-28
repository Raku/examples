#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Swapping values

=AUTHOR Scott Penrose

You want to swap values without using a temporary variable

=end pod

my ($x, $y) = (3, 2);
($x, $y) = ($y, $x);
# XXX Binding (:=) is more efficient, because it doesn't copy the values.
# XXX Compile-time binding (::=) could not be used here, as the cells
#     would be swapped at compile-time, not runtime. ::= doesn't have an effect
#     at runtime:
#         $a ::= $b;  # sugar for
#         BEGIN { $a := $b }
say $x;
say $y;

# vim: expandtab shiftwidth=4 ft=perl6
