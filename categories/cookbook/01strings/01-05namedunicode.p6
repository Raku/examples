#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Using Named Unicode Chars

=AUTHOR stmuk

=end pod

say "\c[REGISTERED SIGN]";

# POUTING CAT FACE
"\x1f63E".say;
"\x1f63E".uniname.say;

# vim: expandtab shiftwidth=4 ft=perl6
