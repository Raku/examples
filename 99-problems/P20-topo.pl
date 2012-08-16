#!/usr/bin/env perl6
use v6;

sub remove-at(@list is copy, $place)
{
    @list.splice($place - 1, 1);
    
    @list
}

say remove-at(<a b c d e>, 4);

=begin pod

=head1 NAME

P20 - Remove the C<k>th element of a list.

=end pod

# vim: ft=perl6
