#!/usr/bin/env perl6

=begin pod

=TITLE Write to a file

=AUTHOR Scott Penrose

=end pod

use v6;

my $tempfile = open('output.txt', :w);
$tempfile.print("Hello world\n");
$tempfile.close;

# vim: expandtab shiftwidth=4 ft=perl6
