#!/usr/bin/env perl6
use v6;

sub replicate(@list, $times)
{
    @list.map({$_ xx $times});
}

say replicate(<a b c c d e>.list, 3);

=begin pod

=head1 NAME

P15 - Replicate the elements of a list a given number of times.

=end pod

# vim: ft=perl6
