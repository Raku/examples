use v6;

=begin pod

=TITLE Largest prime factor

=AUTHOR Eric Hodges

L<https://projecteuler.net/problem=3>

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

=end pod

sub is_prime ($num) {
    for (2..^$num) {
        return 0 unless $num % $_;
    }
    return 1;
};

class Primes {
    has $.current = 0;

    method next {
        $!current++;
        $!current++ until is_prime($.current);
        return $.current;
    }
}

my $prime = Primes.new();
my $number = 600851475143;
my @primes = gather while ($number > 1) {
    if !($number % $prime.next) {
        $number /= $prime.current;
        take $prime.current;
    }
}

say @primes.max;

# vim: expandtab shiftwidth=4 ft=perl6
