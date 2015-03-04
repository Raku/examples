#!/usr/local/bin/perl6

my $tempfile = open('output.txt', :w);
$tempfile.print("Hello world\n");
$tempfile.close;

