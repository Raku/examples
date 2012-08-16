#!/usr/bin/env perl6
use v6;

sub drop-nth(@list, $n)
{
    my $count = 1;

    gather for @list -> $e
    {
        take $e if not $count++ %% $n;
    }
}

say drop-nth(<a b c d e f g h i j k l m n>.list, 3);

=begin pod

=head1 NAME

P16 - Drop every C<n>th element from a list.

=end pod

# vim: ft=perl6
