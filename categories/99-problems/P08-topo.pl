use v6;

=begin pod

=TITLE P08 - Eliminate consecutive duplicates of list elements.

=AUTHOR Ryan Connelly

=head1 Example

    > say eliminate-consecutive-duplicates(<a a a a a b b c b d e e>);
    a b c b d e

=end pod

sub eliminate-consecutive-duplicates(@list)
{
    my $last = ();

    gather for @list -> $e
    {
        # ~~ is the smart match operator.
        # It's the closest thing I can think of to a comparison function
        # which doesn't enforce a particular context... should be alright. :-)
        next if $e ~~ $last;

        $last = $e;

        take $e;
    }
}

say "{eliminate-consecutive-duplicates(<a a a a a b b c b d e e>)}";

# vim: expandtab shiftwidth=4 ft=perl6
