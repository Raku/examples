#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Get character from keyboard

=AUTHOR stmuk

Get single character from keyboard

=end pod

use Term::termios;

my $termios := Term::termios.new(fd => 1).getattr;

# Set the tty to raw mode
$termios.makeraw;

my $c = $*IN.getc;
print "got: " ~ $c.ord ~ "\r\n";

# vim: expandtab shiftwidth=4 ft=perl6
