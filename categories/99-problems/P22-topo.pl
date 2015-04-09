use v6;

=begin pod

=TITLE P22 - Create a list containing all integers within a given range.

=AUTHOR Ryan Connelly

=head1 Example

    > say range(5, 12)
    5 6 7 8 9 10 11 12


=end pod

sub range($lower, $upper)
{
    ($lower ... $upper).list;
}

say range(5, 20).perl;
say range(20, 5).perl;

# vim: expandtab shiftwidth=4 ft=perl6
