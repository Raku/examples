use v6;

=begin pod

=TITLE Largest prime factor

=AUTHOR Mark A. Hershberger

L<https://projecteuler.net/problem=3>

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

Expected result: 6857

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

my $p = Prime.new;
my @q = gather { take $p.next for (0..10) };
my @r;

for (0..10) {
    push @r, $p.next;
}
say @q.join(",");
say @r.join(",");

# vim: expandtab shiftwidth=4 ft=perl6
