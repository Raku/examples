use v6;

=begin pod

=TITLE Digit cancelling fractions

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=33>

The fraction 49/98 is a curious fraction, as an inexperienced
mathematician in attempting to simplify it may incorrectly believe
that 49/98 = 4/8, which is correct, is obtained by cancelling the 9s.

We shall consider fractions like, 30/50 = 3/5, to be trivial examples.

There are exactly four non-trivial examples of this type of fraction,
less than one in value, and containing two digits in the numerator and
denominator.

If the product of these four fractions is given in its lowest common
terms, find the value of the denominator.

=end pod

sub is-curious($num, $den) {
    my @d = $den.comb;
    my @n = $num.comb;
    @d[0] == @n[1] && @n[0]/@d[1] == $num/$den;
}

say 1 / [*] gather for 10 ...^ 100 -> $den {
    for 10 ...^ $den -> $num {
        take $num/$den if is-curious $num, $den;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
