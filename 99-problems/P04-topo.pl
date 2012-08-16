#!/usr/bin/env perl6
use v6;

sub get-num-elems(@list)
{
    @list.elems;
}

say get-num-elems(<a b c d e>);

=begin pod

=head1 NAME

P04 - Find the number of elements in a list.

=end pod

# vim: ft=perl6
