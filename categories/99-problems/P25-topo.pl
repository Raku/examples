use v6;

=begin pod

=TITLE P25 - Generate a random permutation of the elements of a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say permute(<a b c d e>);
    a e d c b

=end pod

sub permute(@list)
{
    @list.pick(*);
}

say permute(<a b c d e>);

# vim: expandtab shiftwidth=4 ft=perl6
