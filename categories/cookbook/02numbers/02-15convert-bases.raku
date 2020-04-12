#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Convert Bases

=AUTHOR stmuk

Convert between various numerical bases

=end pod

say 0xDEADBEEF;

say 0o755;
say 493.fmt("%o");

say :16<FEEDFACE>;
say 4277009102.base(16);

# vim: expandtab shiftwidth=4 ft=perl6
