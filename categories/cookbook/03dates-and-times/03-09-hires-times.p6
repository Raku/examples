#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Hi-Res Timings

=AUTHOR stmuk

You want to measure sub-second timings

=end pod

my $t0 = DateTime.now.Instant;

# apparently not *quite* 2 secs

sleep 2;

say  DateTime.now.Instant - $t0;

# vim: expandtab shiftwidth=4 ft=perl6
