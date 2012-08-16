#!/usr/bin/env perl6
use v6;

sub c(Int $n, [ $x, *@xs ])
{
    if $n  == 0  { return [] }
    if @xs ~~ () { return () }

    map({ [ $x, @^others ] }, c($n - 1, @xs)), c($n, @xs);
}

say c(3, <a b c d e f g h i j k l>);

=begin pod

=head1 NAME

P26 - Generate the combinations of C<k> distinct objects chosen from the C<n> elements of a list.

=end pod

# vim: ft=perl6
