#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Epoch Seconds to DateTime

=AUTHOR stmuk

You want to convert as seconds past the epoch to a datetime (ISO 8601)

=end pod

my $now = 1417793234;
my $dt = DateTime.new($now);

say $dt;

# vim: expandtab shiftwidth=4 ft=perl6
