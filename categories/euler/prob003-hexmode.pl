use v6;

=begin pod

=TITLE Largest prime factor

=AUTHOR Mark A. Hershberger

L<https://projecteuler.net/problem=3>

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

=end pod

class Prime {
    has @!primes;
    has Int $!number = 1;

    method next() {
        my $not_prime = 1;

        while $not_prime && $!number++ {
            $not_prime = @!primes.grep({$!number % $^a == 0});
        }
        @!primes.push($!number);

        my $copy = $!number;
        return $copy;
    }
}

my $number = 600851475143;

my $prime = Prime.new;
my $current-prime;
my @primes = gather repeat {
    $current-prime = $prime.next;
    if $number %% $current-prime {
        take $current-prime;
        $number /= $current-prime;
    }
} while ($current-prime < $number);

say @primes.max;

# vim: expandtab shiftwidth=4 ft=perl6
