#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Opening a file

=AUTHOR Scott Penrose

You want to read or write a file from Perl.

=end pod

my $path = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "07-01opening_file.p6");

my $input = open($path, :r)
    or die "Could not open $path for reading $!\n";

my $filename = "test_file";
my $output = open($filename, :w)
    or die "Could not open $filename for writing $!\n";


# File-access modes
# If you want to use any of the mode parameters you have to put parenthese () after the open.
# :r      read, this is the defaul open mode
# :w      write, automatically creating non existing files and emptying existing files
# :a      append, keep the file intact and enable to write at the end of it
# :rw     read and write
# :r, :w
# :ra     read and append
# :r, :a
#      write and read (overwriting a a file) will we have this?

# Closing the file
$input.close or die $!;
close($output);

say "ok last";

# vim: expandtab shiftwidth=4 ft=perl6
