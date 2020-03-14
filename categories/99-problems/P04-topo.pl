use v6;

=begin pod

=TITLE P04 - Find the number of elements in a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say get-num-elems(<a b c d e>);
    5

=end pod

sub get-num-elems(@list)
{
    @list.elems;
}

say get-num-elems(<a b c d e>);

# vim: expandtab shiftwidth=4 ft=perl6
