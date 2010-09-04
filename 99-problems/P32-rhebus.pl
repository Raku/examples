# Determine the greatest common divisor of two positive integer numbers.
# Use Euclid's algorithm.
#     Example:
#   * (gcd 36 63)
#     9

use v6;

sub gcd (Int $a, Int $b) {
    my ($x,$y) = ($a,$b); 
    while $y != 0 {
        ($x,$y) = ($y, $x mod $y);
    }
    return $x;
}

gcd(36,63).say;


# vim:ft=perl6
