#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Copy/Move File

=AUTHOR stmuk

You want to copy and move a file

=end pod

# create a file
my $f = open "foo", :w;
$f.print(time);
$f.close;

# copy
my $io = IO::Path.new("foo");
$io.copy("foo2");

# clean up
unlink("foo2");

# move
$io.rename("foo2");

# clean up
unlink("foo2");

# vim: expandtab shiftwidth=4 ft=perl6
