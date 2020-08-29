#!/usr/bin/env raku

use v6;

=begin pod

=TITLE Managing Instance data

=AUTHOR uzluisf

=head2 Problem

Each data of an object needs its method for access. How do you write methods 
that manipulate the object's instance data?

=head2 Solution

An attribute declared with the C«$.» have an automatically
generated I«read-only» accessor method named after it. Tagging
the attribute with the C«is rw» trait makes the accessor method I«writable».
=end pod

class Person {
    has $.name is rw;
    has $.age is rw;
}

my Person $p1 .= new: name => 'Sylvia', :age(24);

put $p1.name; #=> Sylvia
put $p1.age;  #=> 24

$p1.name = 'Sylvester';
$p1.age = 23;

put $p1.name; #=> Sylvester
put $p1.age;  #=> 23

# vim: expandtab shiftwidth=4 ft=perl6
