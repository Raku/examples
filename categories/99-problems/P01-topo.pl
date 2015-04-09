use v6;

=begin pod

=TITLE P01 - Find the last element of a list.

=AUTHOR Ryan Connelly

Use of the C<Whatever> type to grab the last element of a list.

=head1 Example

    > say last-elem(<a b c d e>)
    e

=end pod

sub last-elem(@list) {
    @list[* - 1];
}

say last-elem(<a b c d e>);

# vim: expandtab shiftwidth=4 ft=perl6
