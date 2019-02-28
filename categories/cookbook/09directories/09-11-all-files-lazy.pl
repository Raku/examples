#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Process files lazy

=AUTHOR gfldex

You want to recurse over all files in and under a directory in a lazy fashion
and stop after the first three files are found. We filter either based on
methods of IO::Path or on a simple Str match.

=end pod

multi sub find-files(Str:D $dir, &filter = {True}) {
    find-files($dir.IO, &filter)
}

multi sub find-files (IO::Path:D $dir, &filter is copy = {True}) {

# If the argument type of &filter is Str, we append a '/' to directories to
# allow simple Str matches against directories.
    
    my &str-filter = { &filter(.d ?? .Str ~ '/' !! .Str) } if &filter.signature.params[0].type ~~ Str;

    gather for dir($dir) {
        take .IO if (&str-filter ?? str-filter(.IO) !! filter(.IO));
        take slip sort find-files($_, &filter) if .d && (&str-filter ?? str-filter .IO !! filter .IO);
    } but role {

# We mixin a role into the returned Seq to provide one extra method. Calling
# .head would do the same thing but would be less instructive.

        method top(Seq:D: Int $amount){
            my $counter = $amount;
            gather for self {
                take $counter-- ?? $_ !! IterationEnd;
            }
        }
    }
}

sub MAIN(:$dir = "..") {
    my \files = find-files($dir, { 
        (.d && .ends-with(none <tmp mnt>) ) # any directory that doesn't end in tmp or mnt
        || .ends-with(any <.pl .md>) # any file or symlink, etc, that end in .pl and .md
    } );

    for files.top(3) -> $path {
        say $path.Str;
    }

    for find-files($dir, -> Str $_ {.ends-with(none <.md 04arrays/>)}) {
        say .d ?? .Str ~ '/' !! .Str;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
