#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Fetch uri

=AUTHOR stmuk

You want to fetch a uri

=end pod

use LWP::Simple;

my $html = LWP::Simple.get('http://examples.perl6.org/');

say $html;

# vim: expandtab shiftwidth=4 ft=perl6
