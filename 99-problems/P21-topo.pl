#!/usr/bin/env perl6
use v6;

sub insert-at($elem, @list is copy, $place)
{
    @list.splice($place - 1, 0, $elem);

    @list
}

say insert-at('alfa', <a b c d>, 2);

=begin pod

=head1 NAME

P21 - Insert an element at a given position into a list.

=end pod

# vim: ft=perl6
