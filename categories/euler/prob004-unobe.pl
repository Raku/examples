use v6;

=begin pod

=TITLE Largest palindrome product

=AUTHOR David Romano

L<https://projecteuler.net/problem=4>

A palindromic number reads the same both ways. The largest palindrome made
from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.

Expected result: 906609

=end pod

# another case where @array = %*% (100..999) would be nice to have:
# http://use.perl.org/~dpuu/journal/38142
sub diagonal_x (@array) {
    my @result = [];
    my @copy = @array;
    for @copy -> $this {
        @copy.shift;
        for @copy -> $that { @result.push($this * $that); }
    }
    return @result;
}

diagonal_x(100..999).grep({ $_ eq .flip }).sort.reverse.[0].say;

# vim: expandtab shiftwidth=4 ft=perl6
