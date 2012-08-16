#!/usr/bin/env perl6
use v6;

sub duplicate(@list)
{
    @list.map({$_, $_});
}

say duplicate(<a b c c d e>.list);

=begin pod

=head1 NAME

P14 - Duplicate the elements in a list.

=end pod

# vim: ft=perl6
