#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Parsing program arguments

=AUTHOR stmuk

Parse program arguments as passed from the command line

=end pod

##| open file, whatever
sub MAIN (Str :$output!, Bool :$debug = False )  { # False can be ommitted
    warn "debugging" if $debug;
    dd $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
