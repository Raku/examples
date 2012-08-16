#!/usr/bin/env perl6
use v6;

sub split-list(@list, $length)
{
    my $i = 0;
    
    gather while $i <= $length
    {
        take [ gather while $i <= $length {
            $i++ and take @list.shift;
        } ];

        take [ @list ];
    }
}

say split-list('a' xx 20, 8).perl;

=begin pod

=head1 NAME

P17 - Split a list into two parts; the length of the first part is given.

=end pod

# vim: ft=perl6
