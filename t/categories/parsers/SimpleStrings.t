#!/usr/bin/env perl6

use v6;
use Test;

# A simple string parser is defined here:
use lib 'categories/parsers';
use SimpleStrings;

plan(6);

# Save these to variables just for brevity
my $grammar = ::String::Simple::Grammar;
my $actions = String::Simple::Actions.new();

# The semantics of our string are:
# * Backslash before a backslash is backslash
# * Backslash before a quote of the type enclosing the string is that quote
# * All chars including backslash are otherwise literal

ok $grammar.parse(q{"foo"}, :$actions), "Simple string parsing";
is $grammar.parse(q{"foo"}, :$actions).made, "foo", "Content of matched string";
is $grammar.parse(q{"f\oo"}, :$actions).made, "f\\oo", "Content of matched string";
is $grammar.parse(q{"f\"oo"}, :$actions).made, "f\"oo", "Content of matched string";
is $grammar.parse(q{"f\\\\oo"}, :$actions).made, "f\\oo", "Content of matched string";
nok $grammar.parse(q{'f\\\\oo"}, :$actions).made, "Mixed quotes should not work";

 # vim: sw=4 softtabstop=4 ai expandtab filetype=perl6
