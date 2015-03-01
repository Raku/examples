#!/usr/bin/env perl6
use v6;

sub palindromic(@list)
{
    @list ~~ @list.reverse;
}

say palindromic(<a b c d e>.list);
say palindromic(<a b c b a>.list);

=begin pod

=head1 NAME

P06 - Find out whether a list is a palindrome.

=end pod

# vim: expandtab shiftwidth=4 ft=perl6
