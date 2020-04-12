#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Get list of files matching a pattern

=AUTHOR stmuk

You want a list of filenames matching a pattern

=end pod

sub MAIN(:$dir = ".") {
    my @perl-files = dir $dir, test => /\.pl/;

    #  returns a list of IO::Path objects

    for @perl-files.sort -> $io {
        say $io.basename;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
