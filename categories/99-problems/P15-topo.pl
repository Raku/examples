use v6;

=begin pod

=TITLE P15 - Replicate the elements of a list a given number of times.

=AUTHOR Ryan Connelly

=head1 Example

    > say replicate(<a b c c d e>.list, 3);
    a a a b b b c c c c c c d d d e e e

=end pod

sub replicate(@list, $times)
{
    @list.map({$_ xx $times}).flat;
}

say "{replicate(<a b c c d e>.list, 3)}";

# vim: expandtab shiftwidth=4 ft=perl6
