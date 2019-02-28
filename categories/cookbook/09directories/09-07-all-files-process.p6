#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Process files recursively

=AUTHOR stmuk

You want to recurse over all files in and under a directory

=end pod

use File::Find;

sub MAIN(:$dir = ".") {

    my $files = find(:dir($dir), :type('file'));

    for $files.map({.IO}).sort -> $io {
        say $io.absolute;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
