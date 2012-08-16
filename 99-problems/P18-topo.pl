#!/usr/bin/env perl6
use v6;

sub get-slice(@list, $start, $end)
{
    @list[$start - 1 ... $end - 1];
}

say get-slice(<a b c d e>, 2, 4);

=begin pod

=head1 NAME

P18 - Extract a slice from a list. Indices start at 1.

=end pod

# vim: ft=perl6
