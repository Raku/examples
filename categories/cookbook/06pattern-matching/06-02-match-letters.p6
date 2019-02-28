#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Matching alphabetic wide characters

=AUTHOR stmuk

You want to match alphabetic characters which include unicode

=end pod

my $var = "\c[OGHAM LETTER RUIS]";
if $var ~~ /^<:letter>+$/ {   # or just /^<:L>+$/ or even  /^\w+$/
    say "{$var}  is purely alphabetic";
}

# vim: expandtab shiftwidth=4 ft=perl6
