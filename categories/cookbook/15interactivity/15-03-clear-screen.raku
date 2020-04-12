#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Clear the screen

=AUTHOR stmuk

=end pod

if $*DISTRO.is-win {
    shell "cls";
} else {
    shell "clear";
}

# vim: expandtab shiftwidth=4 ft=perl6
