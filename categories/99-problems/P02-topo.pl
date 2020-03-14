use v6;

=begin pod

=TITLE P02 - Find the last two elements of a list.

=AUTHOR Ryan Connelly

Further use of the C<Whatever> type to grab the last elements of a list.

=head1 Example

    > say last-two(<a b c d e>)
    d e

=end pod

sub last-two(@list)
{
    @list[* - 2, * - 1];
}

say "{last-two(<a b c d e>)}";

# vim: expandtab shiftwidth=4 ft=perl6
