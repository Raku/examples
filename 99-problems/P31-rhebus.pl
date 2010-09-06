use v6;

# Specification:
# P31 (**) Determine whether a given integer number is prime.
# Example:
# > say is_prime 7
# 1


sub is_prime (Int $n) {
    for 2..sqrt $n -> $k {
        return Bool::False if $n %% $k;
    }
    return Bool::True;
}

say "Is $_ prime? ", is_prime($_) ?? 'yes' !! 'no'
    for (list(2 .. 10), 49,137,219,1723);

# vim:ft=perl6
