use v6;

=begin pod

=TITLE P06 - Find out whether a list is a palindrome.

=AUTHOR Ryan Connelly

=head1 Example

    > say palindromic(<a b c d e>);
    False
    > say palindromic(<a b c b a>);
    True

=end pod

sub palindromic(@list)
{
    @list ~~ @list.reverse.list;
}

say palindromic(<a b c d e>);
say palindromic(<a b c b a>);

# vim: expandtab shiftwidth=4 ft=perl6
