#!/usr/bin/env perl6
use v6;

sub get-at(@list, $elem)
{
    @list[$elem];
}

say get-at(<a b c d e>, 4);

=begin pod

=head1 NAME

P03 - Find the C<k>th element of a list.

=end pod

# vim: ft=perl6
