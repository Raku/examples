use v6;

# Specification:
#   P32 (**) Determine the greatest common divisor of two positive integer
#       numbers.  Use Euclid's algorithm.
# Example:
# > say gcd(36,63);
# 9


# Example 1: iterative
#   we specify type constraints on our input parameters
sub gcdi (Int $a is copy, Int $b is copy) {
    while $a % $b {
        ($a,$b) = ($b, $a % $b);
    }
    return $b;
}

gcdi(36,63).say;


# Example 2: recursive
#   This can take advantage of a tail-call optimization, if the compiler
#   supports it
#   $a %% $b is true iff $b divides $a evenly. It is equivalent to:
#   !($a % $b)
sub gcdr (Int $a, Int $b) {
    return $b if $a %% $b;
    return gcdr($b, $a % $b);
}

gcdr(36,63).say;
gcdr(63,36).say;

# vim:ft=perl6
