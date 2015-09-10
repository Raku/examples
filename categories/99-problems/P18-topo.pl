use v6;

=begin pod

=TITLE P18 - Extract a slice from a list. Indices start at 1.

=AUTHOR Ryan Connelly

=head1 Example

    > say get-slice(<a b c d e>, 2, 4);
    b c d

=end pod

sub get-slice(@list, $start, $end)
{
    @list[$start - 1 ... $end - 1];
}

say "{get-slice(<a b c d e>, 2, 4)}";

# vim: expandtab shiftwidth=4 ft=perl6
