#!/usr/bin/env perl6
use v6;

sub get-rand-elems(@list, $amount)
{
    @list.pick($amount);
}

say get-rand-elems(<a b c d e>, 3);

=begin pod

=head1 NAME

P23 - Extract a given number of randomly selected elements from a list.

=end pod

# vim: ft=perl6
