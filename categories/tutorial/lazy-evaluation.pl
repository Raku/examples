#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Lazily evaluate items in a list

=AUTHOR Scott Penrose

=end pod

my @fibonacci = 1, 1, { $^a + $^b } ... *;
say @fibonacci[6];     # 13

# vim: expandtab shiftwidth=4 ft=perl6
