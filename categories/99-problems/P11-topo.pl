use v6;

=begin pod

=TITLE P11 - Modified run-length encoding.

=AUTHOR Ryan Connelly

=head1 Example

    > say encode(<a a a a b c c a a d e e e e>.list).perl;
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])

=end pod

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

say encode([<a a a a b c c a a d e e e e>]).list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
