#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE From date to week of year, month of year, day of year

=AUTHOR stmuk

You have a date and want week of year, month of year, day of year

=end pod

my $d = Date.new("1966-08-04");

say "{$d.week-number} {$d.month} {$d.day-of-year}";

# vim: expandtab shiftwidth=4 ft=perl6
