#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Iterating Over an Array

=AUTHOR Scott Penrose

You want to iterate over the elements in an array

=end pod

my @a = <94 13 97 95 12 13 74 10 47 4 62 47 75 36 25 35 0 71 56 50 72 39 30 93>;

for @a -> $e {
    say $e.Str;
}

say $_.Str for @a;

# vim: expandtab shiftwidth=4 ft=perl6
