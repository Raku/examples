use v6;

=begin pod

=TITLE Summation of primes

=AUTHOR polettix

L<https://projecteuler.net/problem=10>

The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

Find the sum of all the primes below two million.

=end pod

# The upper bound, defaults to challenge's request
my $upper_bound = shift(@*ARGS) || 2_000_000;

# A simple implementation of Eratosthenes' sieve. Modified to avoid
# registering stuff beyond the $upper_bound.
sub primes_iterator {
    return sub {
        state %D;
        state $q //= 2;
        while (%D{$q}:exists) {
            my $p = %D{$q};

            my $x = $q + $p;
            $x += $p while %D{$x}:exists;
            %D{$x} = $p if $x <= $upper_bound;
            ++$q;
        }
        my $q2 = $q * $q;
        %D{$q2} = $q if $q2 <= $upper_bound;
        return $q++;
    }
}

my $it = primes_iterator();
my $prime = $it();
my $sum = 0;
my $feedback_threshold = 0; # To give some life signals during computation...
while $prime < $upper_bound {
    $sum += $prime;
    if $prime > $feedback_threshold {
        say "# Processed up to prime number: $prime";
        $feedback_threshold += 10000;
    }
    $prime = $it();
}
say 'result: ', $sum;

# vim: expandtab shiftwidth=4 ft=perl6
