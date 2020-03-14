use v6;

=begin pod

=TITLE P31 - Determine whether a given integer number is prime.

=AUTHOR Philip Potter

=head1 Specification

    P31 (**) Determine whether a given integer number is prime.

=head1 Example

    > say is_prime 7
    1

=end pod

sub is_prime (Int $n) {
    for 2..sqrt $n -> $k {
        return Bool::False if $n %% $k;
    }
    return Bool::True;
}

say "Is $_ prime? ", is_prime($_) ?? 'yes' !! 'no'
    for (|(2 .. 10), 49,137,219,1723);

# vim: expandtab shiftwidth=4 ft=perl6
