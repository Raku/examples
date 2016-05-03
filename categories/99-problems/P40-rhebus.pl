use v6;

=begin pod

=TITLE P40 - Goldbach's conjecture.

=AUTHOR Philip Potter

=head1 Specification

   P40 (**) Goldbach's conjecture.
       Goldbach's conjecture says that every positive even number greater
       than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is
       one of the most famous facts in number theory that has not been proved
       to be correct in the general case. It has been numerically confirmed
       up to very large numbers (much larger than we can go with our Prolog
       system). Write a predicate to find the two prime numbers that sum up
       to a given even integer.

=head1 Example

    > say ~goldbach 28
    5 23

=end pod

subset Even of Int where * %% 2;

sub goldbach (Even $n where * > 2 ) {
    for 2..$n/2 -> $k {
        if $k.is-prime && ($n-$k).is-prime {
            return ($k, $n-$k);
        }
    }
    return; # fail
}

say ~ goldbach $_ for 28, 36, 52, 110, 62710560;

# vim: expandtab shiftwidth=4 ft=perl6
