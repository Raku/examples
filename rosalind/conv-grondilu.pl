#!/usr/bin/perl
use v6;
my ($a, $b) = $*IN.lines;

my %conv; %conv{$_}++ for $a.split(/\s+/) X- $b.split(/\s+/);
.say for max(:by(*.value), %conv).kv.reverse;

# vim: ft=perl6
