#!/usr/bin/env perl6
use v6;

sub lotto-select($n, $m)
{
    gather for ^$n
    {
        take (1 ... $m).pick(1);
    }
}

say lotto-select(6, 49);

=begin pod

=head1 NAME

P24 - Draw C<N> different random numbers from the set C<1..M>.

=end pod

# vim: ft=perl6
