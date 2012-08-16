#!/usr/bin/env perl6
use v6;

sub range($lower, $upper)
{
    ($lower ... $upper).list;
}

say range(5, 20).perl;
say range(20, 5).perl;

=begin pod

=head1 NAME

P22 - Create a list containing all integers within a given range.

=end pod

# vim: ft=perl6
