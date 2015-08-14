use v6;

=begin pod

=TITLE Largest prime factor

=AUTHOR Gerhard R

L<https://projecteuler.net/problem=3>

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

=end pod

sub largest-prime-factor($n is copy) {
    for 2, 3, *+2 ... * {
        while $n %% $_ {
            $n div= $_;
            return $_ if $_ > $n;
        }
    }
}

say largest-prime-factor(600_851_475_143);

# vim: expandtab shiftwidth=4 ft=perl6
