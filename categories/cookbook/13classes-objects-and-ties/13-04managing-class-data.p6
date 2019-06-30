#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Managing Instance data

=AUTHOR uzluisf

=head2 Problem

You need a method invoked on behalf of the whole class, not just a single
instance of the class.

=head2 Solution

In order to do this, a variable that is shared by all the instances of the class
must be created. A variable of this kind is known as a I«class variable» and it
uses the same syntax any other attribute, but it's declared as C«my» or C«our»,
depending on the scope.

It's preferable the method accessing the class variable can only be invoked
on the class and not an instance of the class. To do this, C«::?CLASS:U:» must
be used in the method signature, which indicates it's only callable on the class.
=end pod

class Person {
    has $.name;
    has $.age;

    my $.body-count = 0;

    # overriding the default new construtor to update the counter
    method new( :$name, :$age ) {
        $.body-count++;
        self.bless: :$name, :$age;
    }

    method population( ::?CLASS:U: ) {
        $.body-count
    }
}

my @names = :Eren(19), :Mikasa(19), :Levi(32), :Armin(19), :Erwin(35);
my @people;
for @names -> $name {
    @people.push: Person.new: name => $name.key, age => $name.value;
}

put Person.population; #=> 5

# vim: expandtab shiftwidth=4 ft=perl6
