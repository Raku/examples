=begin pod

=head1 Project Euler Problem 1

=head1 AUTHOR: cspence

=head1 DESCRIPTION

If we list all the natural numbers below 10 that are multiples of 3 or 5, we
get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.

Expected answer: 233168

=end pod

use v6;

(1..^1000).grep({ ! ($^a % 3 and $^a % 5) }).reduce({ $^a + $^b }).say;

# vim: expandtab shiftwidth=4 ft=perl6
