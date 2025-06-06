#!/usr/bin/env perl6

=begin pod

=TITLE Reading from the terminal

=AUTHOR Scott Penrose

=end pod

use v6;

for $*IN.get {
    say "I read the line: $_";
}

# vim: expandtab shiftwidth=4 ft=perl6
