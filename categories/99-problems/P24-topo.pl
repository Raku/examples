use v6;

=begin pod

=TITLE P24 - Draw C<N> different random numbers from the set C<1..M>.

=AUTHOR Ryan Connelly

=head1 Example

    > say lotto-select(6, 49);
    37 8 32 15 21 46

=end pod

sub lotto-select($n, $m)
{
    gather for ^$n
    {
        take (1 ... $m).pick(1).first;
    }
}

say "{lotto-select(6, 49)}";

# vim: expandtab shiftwidth=4 ft=perl6
