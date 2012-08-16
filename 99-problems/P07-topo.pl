#!/usr/bin/env perl6
use v6;

sub flatten(@array)
{
    gather for @array -> $e
    {
        $e ~~ Array ?? take(flatten $e) !! take $e
    }
}

my @a = 1, 2, [3, 4], 5;

say @a.perl;
say 'Flattened:';
say flatten(@a).perl;

=begin pod

=head1 NAME

P07 - Flatten a nested array structure.

=end pod

# vim: ft=perl6
