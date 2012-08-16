#!/usr/bin/env perl6
use v6;

# Use of the Whatever type to grab the last element of a list. 

sub last-elem(@list)
{
    @list[* - 1];
}

say last-elem(<a b c d e>);

=begin pod

=head1 NAME

P01 - Find the last element of a list.

=end pod

# vim: ft=perl6
