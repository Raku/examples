use v6;

=begin pod

=TITLE P10 - Run-length encoding of a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say encode(<a a a a a b b c b d e e>.list).perl;
    ([5, "a"], [2, "b"], [1, "c"], [1, "b"], [1, "d"], [2, "e"]).list

=end pod

sub encode(@ls)
{
    my @list = @ls[*];
    gather while @list.elems {
        my $value = @list[0];
        my $count = 0;

        while @list.elems and @list[0] ~~ $value {
            $count++;
            shift @list
        }

        take [$count, $value];
    }
}

say encode(<a a a a a b b c b d e e>).list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
