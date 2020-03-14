use v6;

=begin pod

=TITLE P09 - Pack consecutive duplicate elements of a list into sublists.

=AUTHOR Ryan Connelly

=head1 Example

    > say pack-consecutive-dups(<a a a a a b b c b d e e>.list).perl;
    > (["a", "a", "a", "a", "a"], ["b", "b"], ["c"], ["b"], ["d"], ["e", "e"]).list

=end pod

sub pack-consecutive-dups(@list)
{
    gather while @list.elems
    {
        my $last = @list[0];

        take [
            gather while @list.elems
                   and @list[0] ~~ $last
            {
                take ($last = @list.shift)
            }
        ]
    }.list
}

say pack-consecutive-dups([<a a a a a b b c b d e e>]).perl;

# vim: expandtab shiftwidth=4 ft=perl6
