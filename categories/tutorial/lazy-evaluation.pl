#!/usr/bin/env perl6

use v6;

my @fibonacci = 1, 1, { $^a + $^b } ... *;
say @fibonacci[6];     # 13

# vim: expandtab shiftwidth=4 ft=perl6
