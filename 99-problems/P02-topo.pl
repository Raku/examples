#!/usr/bin/env perl6
use v6;

# Further use of the Whatever type to grab the last elements of a list. 

sub last-two(@list)
{
    @list[* - 2, * - 1];
}

say last-two(<a b c d e>);

=begin pod

=head1 NAME

P02 - Find the last two elements of a list.

=end pod

# vim: ft=perl6
