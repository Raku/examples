use v6;

=begin pod

=TITLE Digit fifth powers

=AUTHOR Andrei Osipov

Surprisingly there are only three numbers that can be written as the
sum of fourth powers of their digits:

        1634 = 1⁴ + 6⁴ + 3⁴ + 4⁴
        8208 = 8⁴ + 2⁴ + 0⁴ + 8⁴
        9474 = 9⁴ + 4⁴ + 7⁴ + 4⁴

As 1 = 14 is not a sum it is not included.

The sum of these numbers is 1634 + 8208 + 9474 = 19316.

Find the sum of all the numbers that can be written as the sum of
fifth powers of their digits.

=end   pod

sub get-numbers(:$start = 10, :$depth = 6, *@a) {
    return $@a unless $depth;
    flat do for ^$start -> \x {
        get-numbers start => x + 1,
                    depth => $depth -1, |@a,x;
    }
}

say [+] gather for get-numbers() -> @a {
    my $v = [+] @a »**» 5;
    my $b = [+] $v.comb.list »**» 5;
    take $b if $v == $b;
    LAST take -1;
}

# vim: expandtab shiftwidth=4 ft=perl6
