use v6;

=begin pod

=TITLE Combinatoric selections

=AUTHOR Gerhard R

L<https://projecteuler.net/problem=53>

There are exactly ten ways of selecting three from five, 12345:

123, 124, 125, 134, 135, 145, 234, 235, 245, and 345

In combinatorics, we use the notation, ⁵C₃ = 10.

In general,

    ⁿCᵣ = n! / r!(n−r)! ,where r ≤ n, n! = n×(n−1)×...×3×2×1, and 0! = 1.

It is not until n = 23, that a value exceeds one-million: ²³C₁₀ = 1144066.

How many, not necessarily distinct, values of ⁿCᵣ, for 1 ≤ n ≤ 100, are
greater than one-million?

=end pod

$[1], -> @p { $[0, |@p Z+ |@p, 0] } ... * \ # generate Pascal's triangle
==> (*[0..100])() \
==> map *.Slip \
==> grep * > 1_000_000 \
==> elems() \
==> (*.say)()

# vim: expandtab shiftwidth=4 ft=perl6
