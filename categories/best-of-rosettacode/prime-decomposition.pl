use v6;

=begin pod

=TITLE Prime decomposition

=AUTHOR TimToady

The prime decomposition of a number is defined as a list of prime numbers
which when all multiplied together, are equal to that number.

Example: 12 = 2 × 2 × 3, so its prime decomposition is {2, 2, 3}

=head1 Task

Write a function which returns an array or collection which contains the
prime decomposition of a given number, n, greater than 1. If your language
does not have an isPrime-like function available, you may assume that you
have a function which determines whether a number is prime (note its name
before your code).

=head1 More

L<http://rosettacode.org/wiki/Prime_decomposition#Raku>

=end pod

my @primes = 2, 3, 5, -> $n is copy {
    repeat { $n += 2 } until $n %% none @primes ... { $_ * $_ >= $n }
    $n;
} ... *;

sub factors(Int $remainder is copy) {
    return 1 if $remainder <= 1;
    gather for @primes -> $factor {
        if $factor * $factor > $remainder {
            take $remainder if $remainder > 1;
            last;
        }

        # How many times can we divide by this prime?
        while $remainder %% $factor {
            take $factor;
            last if ($remainder div= $factor) === 1;
        }
    }
}

say "{factors 536870911}";

# vim: expandtab shiftwidth=4 ft=perl6
