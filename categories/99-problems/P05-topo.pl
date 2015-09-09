use v6;

=begin pod

=TITLE P05 - Reverse a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say reverse-list(<a b c d e>);
    e d c b a

=end pod

sub reverse-list(@list)
{
    @list.reverse;
}

say "{reverse-list(<a b c d e>)}";

# vim: expandtab shiftwidth=4 ft=perl6
