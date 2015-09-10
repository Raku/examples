use v6;

=begin pod

=TITLE P07 - Flatten a nested array structure.

=AUTHOR Johan Viklund

We use the gather/take structure.

A gather block builds a list using take statements. Each take adds one
element to the list. The gather block returns the complete list.

A gather block operates with dynamic scope, so the take statements may be
in another subroutine.

=item for @t -> $t

iterates over C<@t>, placing each element in turn in C<$t>

=item ~~

is the smart match operator. Here we use it to check the type of C<$t>.
we could have said C<$t.isa(Array)> instead.

=head1 Specification

   P07 (**) Flatten a nested array structure.
       Transform an array, possibly holding arrays as elements into a `flat'
       list by replacing each array with its elements (recursively).

=head1 Example

    > splat([1,[2,[3,4],5]]).perl.say;
    (1, 2, 3, 4, 5)

=end pod

sub _splat(@t) {
    for @t -> $t {
        if $t ~~ Array { _splat($t) }
        else           { take $t }
    }
}

sub splat (@t) { gather _splat(@t) }

splat([1, [2,[3,4], 5]]).list.perl.say;

# vim: expandtab shiftwidth=4 ft=perl6
