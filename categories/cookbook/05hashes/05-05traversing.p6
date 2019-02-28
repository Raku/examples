#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Traversing a hash

=AUTHOR Scott Penrose

You want to perform an action on each entry (i.e., each pair) in a hash.

=end pod

my %hash = (
    'one'   => 'un',
    'two'   => 'deux',
    'three' => 'trois'
);

for %hash.sort(*.key)>>.kv -> ($key, $value) {
    say "The word '$key' is '$value' in French.";
}

for %hash.keys.sort -> $key {
    say "$key => %hash{$key}";
}

for %hash.sort {
    .say;
}

# vim: expandtab shiftwidth=4 ft=perl6
