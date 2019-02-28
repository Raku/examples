#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Copy and substitute simultaneously 

=AUTHOR stmuk

You want to copy and substitute simultaneously

=end pod

my $src = "BBC";

(my $dst = $src ) ~~ s/^B/A/;

say :$dst.perl;

# vim: expandtab shiftwidth=4 ft=perl6
