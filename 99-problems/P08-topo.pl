#!/usr/bin/env perl6
use v6;

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

say eliminate-consecutive-duplicates(<a a a a a b b c b d e e>);

=begin pod

=head1 NAME

P08 - Eliminate consecutive duplicates of list elements.

=end pod

# vim: ft=perl6
