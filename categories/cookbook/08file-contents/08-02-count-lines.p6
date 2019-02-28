#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Count File Lines

=AUTHOR stmuk

You want to count the number of lines in a file

=end pod

my @lines = $*PROGRAM-NAME.IO.lines;

say @lines.elems;

# vim: expandtab shiftwidth=4 ft=perl6
