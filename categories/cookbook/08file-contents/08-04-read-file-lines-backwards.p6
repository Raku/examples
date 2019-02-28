#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Read file lines backwards

=AUTHOR stmuk

You want to read file lines backwards

=end pod

my @lines = $*PROGRAM-NAME.IO.lines;
@lines .= reverse;

for @lines -> $line {
    dd $line;
}

# vim: expandtab shiftwidth=4 ft=perl6
