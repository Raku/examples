use v6;

=begin pod

=TITLE Large non-Mersenne prime

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=97>

The first known prime found to exceed one million digits was
discovered in 1999, and is a Mersenne prime of the form 26972593−1; it
contains exactly 2,098,960 digits. Subsequently other Mersenne primes,
of the form 2p−1, have been found which contain more digits.

However, in 2004 there was found a massive non-Mersenne prime which
contains 2,357,207 digits: 28433×2**7830457+1.

Find the last ten digits of this prime number.

=end pod

sub power-mod($b is copy, $e is copy, $m is copy
                                       where $b & $e & $m > 0)  {
    my $r = 1;
    while $e != 0 {
        $r = $r * $b mod $m if $e !%% 2;
        $e = floor $e/2;
        $b = $b ** 2 mod $m
    }
    $r;
}

say (power-mod(2, 7830457, 10**10) * 28433 + 1) mod 10**10 ;

# vim: expandtab shiftwidth=4 ft=perl6
