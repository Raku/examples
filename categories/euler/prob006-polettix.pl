use v6;

=begin pod

=TITLE Sum square difference

=AUTHOR polettix

L<https://projecteuler.net/problem=6>

The sum of the squares of the first ten natural numbers is,

    1**2 + 2**2 + ... + 10**2 = 385

The square of the sum of the first ten natural numbers is,

    (1 + 2 + ... + 10)**2 = 55**2 = 3025

Hence the difference between the sum of the squares of the first
ten natural numbers and the square of the sum is 3025 - 385 = 2640.

Find the difference between the sum of the squares of the first
one hundred natural numbers and the square of the sum.

=end pod

# Upper bound optionally taken from command line, defaults to
# challenge's request
my $upper = shift(@*ARGS) || 100;

# This is quite straightforward: the sum of the first N positive
# integers is easily computed as (N + 1) * N / 2, hence the square
# is straightforward. We then subtract the square of each single
# one to get the final result.
my $result = (($upper + 1) * $upper / 2) ** 2;
$result -= $_ ** 2 for 1 .. $upper;
say $result;

# vim: expandtab shiftwidth=4 ft=perl6
