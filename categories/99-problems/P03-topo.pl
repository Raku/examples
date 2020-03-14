use v6;

=begin pod

=TITLE P03 - Find the C<k>th element of a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say get-at(<a b c d e>, 4)
    e

=end pod

sub get-at(@list, $elem)
{
    @list[$elem];
}

say get-at(<a b c d e>, 4);

# vim: expandtab shiftwidth=4 ft=perl6
