#!/usr/bin/env perl6
use v6;

sub reverse-list(@list)
{
    @list.reverse;
}

# Make sure it's treated as a list, since <> creates a parcel.
say reverse-list(<a b c d e>.list);

=begin pod

=head1 NAME

P05 - Reverse a list.

=end pod

# vim: ft=perl6
