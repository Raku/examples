#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Get/Set Filetime

=AUTHOR stmuk

You want to get and set a utime on a file's inode

=end pod

my $fn =  $?FILE;

my Instant $i = $fn.IO.accessed;
my $dt = $i.to-posix;

say :$dt.perl;

# vim: expandtab shiftwidth=4 ft=perl6
