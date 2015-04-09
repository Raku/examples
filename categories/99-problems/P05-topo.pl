use v6;

=begin pod

=TITLE P05 - Reverse a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say reverse-list(<a b c d e>.list);
    e d c b a

=end pod

sub reverse-list(@list)
{
    @list.reverse;
}

# Make sure it's treated as a list, since <> creates a parcel.
say reverse-list(<a b c d e>.list);

# vim: expandtab shiftwidth=4 ft=perl6
