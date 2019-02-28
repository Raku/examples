#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Specifying a list in your program

=AUTHOR Scott Penrose

You want to include a list in your program.  This is how to initialize arrays.

=end pod

# comma separated list of elements
my @a = ('alpha', 'beta', 'gamma');
say @a[1];

# angle brackes to autoquote items
{
    my @a = <alpha beta gamma>;

    for @a -> $e {
        say $e;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
