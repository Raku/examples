#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Constructing an object

=AUTHOR Scott Penrose

=head2 Problem

You want to create a way for your users to generate new objects

=head2 Solution

Merely declare the class.  Constructors are provided for you automatically.

=end pod

class Foo {}

my $foo = Foo.new;
say $foo ~~ Foo ?? "Yes" !! "No";

# vim: expandtab shiftwidth=4 ft=perl6
