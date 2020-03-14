use v6;

=begin pod

=TITLE P13 - Direct run-length encoding.

=AUTHOR Ryan Connelly

=head1 Example

    > say encode(<a a a a b c c a a d e e e e>.list).perl;
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"]).list

=end pod

# I can't see the difference between this and P11.
# Perhaps I'm being stupid.

sub encode(@list)
{
    gather while @list.elems {
        my $value = @list[0];
        my $count = 0;

        while @list.elems and @list[0] ~~ $value {
            $count++;
            shift @list
        }

        take $count == 1 ?? $value !! [$count, $value];
    }
}

say encode(<a a a a b c c a a d e e e e>.Array).list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
