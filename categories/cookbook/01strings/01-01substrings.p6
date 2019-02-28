#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Substrings

=AUTHOR Scott Penrose

You want to access or modify a portion of a string, not the whole thing.

=end pod

my ($string, $offset, $count) = ('Rakudo is da bomb', 2, 7);
say $string.substr($offset, $count);
say $string.substr($offset);

# want to replace everything but the first two letters with the string
# "diators are nice in winter"
# this code works in Perl 5, but not in Perl 6 since strings are immutable
# substr($string, $offset) = "diators are nice in winter";
# say $string;
$string = $string.substr(0, $offset) ~ "diators are nice in winter";
say $string;

# vim: expandtab shiftwidth=4 ft=perl6
