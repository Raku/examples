#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Reversing a String by Word or Character

=AUTHOR stmuk

You want to reverse words or characters in a string

=end pod

my $string = "The Magic Words are Squeamish Ossifrage";

# reverse the characters in a scalar

say $string.flip;

# reverse the words in a scalar

say $string.split(" ").reverse.join(" ");

# vim: expandtab shiftwidth=4 ft=perl6
