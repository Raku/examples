#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Process every word in a file

=AUTHOR stmuk

You want to process every word in a file

=end pod

my @words = $*PROGRAM-NAME.IO.words;

for @words -> $word {
    dd $word;
}


# vim: expandtab shiftwidth=4 ft=perl6
