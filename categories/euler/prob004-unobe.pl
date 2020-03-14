use v6;

=begin pod

=TITLE Largest palindrome product

=AUTHOR David Romano

L<https://projecteuler.net/problem=4>

A palindromic number reads the same both ways. The largest palindrome made
from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.

=end pod

# another case where @array = %*% (100..999) would be nice to have:
# http://use.perl.org/~dpuu/journal/38142
sub diagonal_x (@array is copy) {
        
    gather while @array.shift -> $this {
        for @array -> $that { take $this * $that  }
    }
}

diagonal_x(100...999).grep({ $_ eq $_.flip }).sort.reverse.[0].say;

# vim: expandtab shiftwidth=4 ft=perl6
