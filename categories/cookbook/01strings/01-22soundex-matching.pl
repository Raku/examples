#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Soundex Matching

=AUTHOR stmuk

You have two surnames and want to know if they sound similar

=end pod

use Algorithm::Soundex;

my Algorithm::Soundex $s .= new();

say  $s.soundex("Smith");
say  $s.soundex("Smythe");
say  $s.soundex("Bloggs");

# vim: expandtab shiftwidth=4 ft=perl6
