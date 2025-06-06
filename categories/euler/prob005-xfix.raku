use v6;

=begin pod

=TITLE Smallest multiple

=AUTHOR Konrad Borowski

L<https://projecteuler.net/problem=5>

2520 is the smallest number that can be divided by each of the numbers from
1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the
numbers from 1 to 20?

=end pod

say [lcm] 1..20;

# vim: expandtab shiftwidth=4 ft=perl6
