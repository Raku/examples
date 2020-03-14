use v6;

=begin pod

=TITLE Power digit sum

=AUTHOR L. Grondin

L<https://projecteuler.net/problem=16>

2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.

What is the sum of the digits of the number 2^1000?

=end pod

say 2**1000 .comb.sum;

# vim: expandtab shiftwidth=4 ft=perl6
