use v6;

# Specification:
#   P36 (**) Determine the prime factors of a given positive integer (2).
#       Construct a list containing the prime factors and their multiplicity.
# Example:
# > prime_factors_mult(315).perl.say
# (3 => 2, 5 => 1, 7 => 1)
#
#   Hint: The problem is similar to problem P13.


sub prime_factors_mult (Int $n) {
    my $residue = $n;
    gather for (2,3,*+2 ... * > $n) -> $k {
        my $mult=0;
        while $residue %% $k {
            $mult++;
            $residue div= $k;
        }
        take $k => $mult if $mult;
        last if $residue == 1;
        # This if block is an optimisation which reduces number of iterations
        # for numbers with large prime factors (such as large primes)
        # It can be removed without affecting correctness.
        if $k > sqrt $residue {
            take $residue => 1;
            last;
        }
    }
}

say prime_factors_mult($_).perl for 1..20;
prime_factors_mult(315).perl.say;
prime_factors_mult(1723).perl.say;
    

# vim:ft=perl6
