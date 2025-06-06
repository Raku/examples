use v6;

=begin pod

=TITLE P16 - Drop every C<n>th element from a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say drop-nth(<a b c d e f g h i j k l m n>.list, 3);
    a b d e g h j k m n

=end pod

sub drop-nth(@list, $n)
{
    my $count = 1;

    gather for @list -> $e
    {
        take $e if not $count++ %% $n;
    }
}

say "{drop-nth(<a b c d e f g h i j k l m n>.list, 3)}";

# vim: expandtab shiftwidth=4 ft=perl6
