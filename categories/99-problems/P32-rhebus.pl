use v6;

=begin pod

=TITLE P32 - Determine the greatest common divisor of two positive integer

=AUTHOR Philip Potter

=head1 Specification

   P32 (**) Determine the greatest common divisor of two positive integer
       numbers.  Use Euclid's algorithm.

=head1 Example

    > say gcd(36,63);
    9

=end pod

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

# Example 3: series operator
#   The series operator generates series lazily. It takes some start terms, a
#   generation rule, and possibly a limit, and produces a series.
#   To create the Fibonacci series, we write:
#       (1, 1, *+* ... *)
#   The generation rule is to sum the previous two terms: *+*.
#   A limit of * continues the series forever.
#
#   We exploit this to generate the series of intermediate values in Euclid's
#   algorithm: each step in the series is the mod of the last two terms. When
#   we reach 0, the term before that was the gcd.
sub gcds (Int $a, Int $b) {
    return ($a, $b, *%* ... 0)[*-2];
}

gcds(8,12).say;
gcds(36,63).say;
gcds(63,36).say;

# vim: expandtab shiftwidth=4 ft=perl6
