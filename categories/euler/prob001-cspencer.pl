use v6;

=begin pod

=TITLE Multiples of 3 and 5

=AUTHOR cspence

L<https://projecteuler.net/problem=1>

If we list all the natural numbers below 10 that are multiples of 3 or 5, we
get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.

=end pod

(1..^1000).grep({ ! ($^a % 3 and $^a % 5) }).reduce({ $^a + $^b }).say;

# vim: expandtab shiftwidth=4 ft=perl6
