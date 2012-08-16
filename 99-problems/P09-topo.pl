#!/usr/bin/env perl6
use v6;

sub pack-consecutive-dups(@list)
{
    gather while @list.elems
    {
        my $last = @list[0];
        
        take [
            gather while @list.elems
                   and @list[0] ~~ $last
            {
                take ($last = shift @list)
            }
        ]
    }
}

say pack-consecutive-dups(<a a a a a b b c b d e e>.list).perl;

=begin pod

=head1 NAME

P09 - Pack consecutive duplicate elements of a list into sublists.

=end pod

# vim: ft=perl6
