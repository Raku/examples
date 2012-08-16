#!/usr/bin/env perl6
use v6;

sub permute(@list)
{
    @list.pick(*);
}

say permute(<a b c d e>);

=begin pod

=head1 NAME

P25 - Generate a random permutation of the elements of a list.

=end pod

# vim: ft=perl6
