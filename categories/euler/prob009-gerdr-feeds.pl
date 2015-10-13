use v6;

=begin pod

=TITLE Special Pythagorean triplet

=AUTHOR Gerhard R

L<https://projecteuler.net/problem=9>

A Pythagorean triplet is a set of three natural numbers, a < b < c, for
which,

    a^2 + b^2 = c^2

For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.

=end pod

constant $N = 1000;

my $result;
1..Int((1 - sqrt(0.5)) * $N) \

# compute numerator and denominator of closed expression for b
==> map -> $a { [ $a, $N * ($N - 2 * $a), 2 * ($N - $a) ] } \

# check if closed expression yields an integer
==> grep -> [ $a, $u, $v ] { $u %% $v } \

# compute b and c
==> map -> [ $a, $u, $v ] { my $b = $u div $v; [ $a, $b, $N - $a - $b ] } \

# compute product
==> map -> @triple { [*] @triple } \

# ... to give the result.
# XXX Rakudo feed operator wraps results in an extra sequence, thus .[0]
==> { .[0].say }();

# vim: expandtab shiftwidth=4 ft=perl6
