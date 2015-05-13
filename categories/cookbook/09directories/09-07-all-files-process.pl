use v6;

=begin pod

=TITLE Process files recursively

=AUTHOR stmuk

You want to recurse over all files in and under a directory

=end pod

use File::Find;

# note binding := for a list

my @files := find(:dir("/etc"), :type('file'));

#  returns a list of IO::Path objects

for @files -> $io {
    say $io.abspath;
}

# vim: expandtab shiftwidth=4 ft=perl6
