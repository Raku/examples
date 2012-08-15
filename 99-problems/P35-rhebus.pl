use v6;

# Specification:
# P35 (**) Determine the prime factors of a given positive integer.
#   Construct a flat list containing the prime factors in ascending order.
# Example:
# > say ~prime_factors 315
# 3 3 5 7


sub prime_factors (Int $n) {
    my $residue = $n;
    gather for (2,3,*+2 ... * > $n) -> $k {
        while $residue %% $k {
            # try 'take 0+$k' to work around a known rakudo issue (2010-09-05)
            take $k;
            $residue /= $k;
        }
        last if $residue == 1;
        # This if block is an optimisation which reduces number of iterations
        # for numbers with large prime factors (such as large primes)
        # It can be removed without affecting correctness.
        if $k > sqrt $residue {
            take $residue;
            last;
        }
    }
}

say ~prime_factors($_) for 2..20;
say ~prime_factors(315);
say ~prime_factors(1723);
    

# vim:ft=perl6
