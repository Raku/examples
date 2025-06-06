use v6;

=begin pod

=TITLE Pandigital products

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=32>

We shall say that an n-digit number is pandigital if it makes use of
all the digits 1 to n exactly once; for example, the 5-digit number,
15234, is 1 through 5 pandigital.

The product 7254 is unusual, as the identity, 39 × 186 = 7254,
containing multiplicand, multiplier, and product is 1 through 9
pandigital.

Find the sum of all products whose multiplicand/multiplier/product
identity can be written as a 1 through 9 pandigital.  HINT: Some
products can be obtained in more than one way so be sure to only
include it once in your sum.

=end   pod

sub is-pandigital($n is copy) {
    # #`«17x slower» return so all $n.comb.one == all 1..9;
    return unless 123456789 <= $n <= 987654321;
    my $x = 0;
    loop ( ; $n != 0 ; $n div=10) {
        my $d = $n mod 10;
        $x += $d * 10 ** (9 - $d);
    }
    $x == 123456789;
}

sub is-unusual($a, $b) {
    my $p = $a * $b;
    my $la = chars $a;
    my $lb = chars $b;
    my $lp = chars $p;

    return unless $la +$lb + $lp == 9;

    my $x = $a * 10 ** (9 - $la) + $b * (10 ** $lp) + $p;

    is-pandigital $x;
}


say [+] unique gather for 1 ... 2000 -> $x {
    for 1 ... 50 -> $y {
        take $x * $y if is-unusual $x, $y
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
