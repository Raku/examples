#!/usr/bin/env raku

use v6;

=begin pod

=TITLE Overloading operators

=AUTHOR uzluisf

=head2 Problem

You want to use familiar operators like C«==» or C«+» on objects from a
class you've written, or you want to define the print interpolation value for
objects.


=head2 Solution

Operators are declared by using the C«sub» (or C«multi») keyword followed by the 
keyword indicating the operator's place with respect to the operand(s). For instance,
for an operator between two operands, the C«infix» is used. This is all followed 
by a colon and the operator name in a quote construct. 

As for how the class (or instances of it) is printed, it's matter of implementing
a version of the C«gist» method specific to the class. This method is responsible 
for providing a default representation of the class and it's called by the
C«say» routine by default.
=end pod

=comment Overloading operators

class Cents {
    has Int $.value;
}

multi infix:<+>( Cents $q1, Cents $q2 ) {
    $q1.value + $q2.value
}

multi infix:<->( Cents $q1, Cents $q2 ) {
    $q1.value - $q2.value
}

my Cents $c1 .= new: :value(100);
my Cents $c2 .= new: :value(45);

put $c1 + $c2; # 145
put $c1 - $c2; # 55

=comment Overriding the gist method

class PrintableCents {
    has Int $.value;

    method gist {
        return "$!value¢" if $!value < 100;
        return '$' ~ $!value/100 
    }
}

my $below-a-dollar = PrintableCents.new: value => 25;
my $over-a-dollar  = PrintableCents.new: value => 275;

say $below-a-dollar;     # 25¢
put $over-a-dollar.gist; # $2.75

# vim: expandtab shiftwidth=4 ft=perl6
