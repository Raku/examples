#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE DateTime to Epoch Seconds

=AUTHOR stmuk

You want a datetime (ISO 8601) as seconds past the epoch.

=end pod

my $dt = DateTime.new("1981-06-17T00:00:00Z");

say $dt.posix;

# vim: expandtab shiftwidth=4 ft=perl6
