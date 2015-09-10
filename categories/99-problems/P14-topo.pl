use v6;

=begin pod

=TITLE P14 - Duplicate the elements in a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say duplicate(<a b c c d e>.list);
    a a b b c c c c d d e e

=end pod

sub duplicate(@list)
{
    @list.map({$_, $_}).flat;
}

say "{duplicate(<a b c c d e>.list)}";

# vim: expandtab shiftwidth=4 ft=perl6
