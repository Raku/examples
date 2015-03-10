#!/usr/bin/env perl6

=begin pod

=TITLE Reading from a file

=AUTHOR Scott Penrose

=end pod

use v6;

my $tempfile = open('lorem.txt', :r);
my $first_line = $tempfile.get;
say $first_line;

# vim: expandtab shiftwidth=4 ft=perl6
