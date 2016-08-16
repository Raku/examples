#!/usr/bin/env perl6

use v6;
use Test;

# A simple string parser is defined here:
use lib 'categories/parsers';
use CSSGrammar;

plan(8);

# Save these to variables just for brevity
my $grammar = CSSGrammar;

ok $grammar.parse(q<H1 { color: blue; }>), "ruleset, basic";
ok $grammar.parse(q<42 7% 12.5cm -1em 2 ex 45deg 10s 50Hz 'ZZ' counter(a,b) counters(p,'s') attr(data-foo)>, :rule<expr>), "expressions";
ok $grammar.parse(q<A:Visited + .some_class:link + H1[lang=fr]>, :rule<selector>), "selector";
ok $grammar.parse(q<@import url('file:///etc/passwd');>, :rule<import>), 'import url';
ok $grammar.parse(q<@import '/etc/passwd';>), 'import file';
ok $grammar.parse(q<body{margin: 1cm; color: red;}>, :rule<ruleset>), 'ruleset';
ok $grammar.parse(q<@media print {body{margin: 1cm}}>), '@media rule';
ok $grammar.parse(q<@Page :first { margin-right: 2cm }>), '@page rule';

# vim: sw=4 softtabstop=4 ai expandtab filetype=perl6
