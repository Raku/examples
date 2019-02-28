#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Test whether program is interactive or not

=AUTHOR stmuk

Test whether program is interactive or not
running from terminal or in batch mode (like cron on UNIX)

=end pod

sub I-am-interactive {
    return  $*IN.t && $*OUT.t;
}

# vim: expandtab shiftwidth=4 ft=perl6
