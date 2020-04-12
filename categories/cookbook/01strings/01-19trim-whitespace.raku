#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Trimming whitespace from both ends of a string

=AUTHOR stmuk

You have a string with leading and/or trailing whitespace
you wish to remove

=end pod

my $string = "\t the cat sat on the mat  ";

$string.=trim;

say :$string.perl;

# vim: expandtab shiftwidth=4 ft=perl6
