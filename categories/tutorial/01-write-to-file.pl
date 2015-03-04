#!/usr/bin/env perl6

use v6;

my $tempfile = open('output.txt', :w);
$tempfile.print("Hello world\n");
$tempfile.close;

# vim: expandtab shiftwidth=4 ft=perl6
