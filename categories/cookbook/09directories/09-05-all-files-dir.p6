#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Process all files in a directory

=AUTHOR stmuk

You want to process all files in a directory

=end pod

sub MAIN(:$dir = ".") {
    # print a string representation of each file's path
    for dir($dir).sort -> $file {
        say Str($file);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
