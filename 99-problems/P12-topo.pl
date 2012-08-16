#!/usr/bin/env perl6
use v6;

sub decode(@list)
{
    gather for @list -> $e
    {
        $e !~~ Array ?? take($e) !! take($e[1] xx $e[0])
    }
}

say decode(([5, "a"], [2, "b"], "c", "b", "d", [2, "e"]).list).perl;

=begin pod

=head1 NAME

P12 - Decode modified run-length encoding.

=end pod

# vim: ft=perl6
