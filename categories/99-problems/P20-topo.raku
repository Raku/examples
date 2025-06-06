use v6;

=begin pod

=TITLE P20 - Remove the C<k>th element of a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say remove-at(<a b c d e>, 4);
    a b c e

=end pod

sub remove-at(@list is copy, $place)
{
    @list.splice($place - 1, 1);

    @list
}

say "{remove-at(<a b c d e>, 4)}";

# vim: expandtab shiftwidth=4 ft=perl6
