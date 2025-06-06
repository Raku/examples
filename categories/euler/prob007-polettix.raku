use v6;

=begin pod

=TITLE 10001st prime

=AUTHOR polettix

L<https://projecteuler.net/problem=7>

By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see
that the 6th prime is 13.

What is the 10001st prime number?

=end pod

# A simple implementation of Eratosthenes' sieve
sub primes_iterator {
    return sub {
        state %D;
        state $q //= 2;
        while %D{$q}:exists {
            my $p = %D{$q}:delete;

            my $x = $q + $p;
            $x += $p while %D{$x} :exists;
            %D{$x} = $p;
            ++$q;
        }
        %D{$q * $q} = $q;
        return $q++;
    }
}

#= nth: The number of primes we want, defaults to challenge's request
#= vebose: print verbose progress information
sub MAIN(Int :$nth = 10001, Bool :$verbose = False) {
    my $it = primes_iterator();
    for 1 .. $nth - 1 -> $i {
        $it();
        if $verbose {
            say "found $i primes so far" unless $i % 100;
        }
    }

    say $it();
}

# vim: expandtab shiftwidth=4 ft=perl6
