use v6;

=begin pod

=TITLE Largest palindrome product

=AUTHOR Konrad Borowski

L<https://projecteuler.net/problem=4>

A palindromic number reads the same both ways. The largest palindrome made
from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.

=end pod

my @nums = 100..^1000;
say (@nums X* @nums).grep({.flip eq $_}).max;

# vim: expandtab shiftwidth=4 ft=perl6
