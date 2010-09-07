use v6;

# Specification:
#   P40 (**) Goldbach's conjecture.
#       Goldbach's conjecture says that every positive even number greater
#       than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is
#       one of the most famous facts in number theory that has not been proved
#       to be correct in the general case. It has been numerically confirmed
#       up to very large numbers (much larger than we can go with our Prolog
#       system). Write a predicate to find the two prime numbers that sum up
#       to a given even integer.
#
# Example:
# > say ~goldbach 28
# 5 23


# From P31-rhebus.pl again
sub is_prime (Int $n) {
    for 2..sqrt $n -> $k {
        return Bool::False if $n %% $k;
    }
    return Bool::True;
}


# require even arguments
sub goldbach (Int $n where {$^a > 2 && $^a %% 2}) {
    for 2..$n/2 -> $k {
        if is_prime($k) && is_prime($n-$k) {
            return ($k, $n-$k);
        }
    }
    return; # fail
}

say ~goldbach $_ for 28, 36, 52, 110;

# vim:ft=perl6
