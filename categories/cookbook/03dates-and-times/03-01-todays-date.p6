#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Today's Date

=AUTHOR stmuk

You want year, month and day for today's date.

=end pod

my $d = Date.today;

say "{$d.year} {$d.month} {$d.day}";

# vim: expandtab shiftwidth=4 ft=perl6
