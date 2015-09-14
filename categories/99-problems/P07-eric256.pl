use v6;

=begin pod

=TITLE P07 - Flatten a nested array structure.

=AUTHOR Eric Hodges

=head1 Specification

   P07 (**) Flatten a nested array structure.
       Transform an array, possibly holding arrays as elements into a `flat'
       list by replacing each array with its elements (recursively).

=head1 Example

    > splat([1,[2,[3,4],5]]).perl.say;
    (1, 2, 3, 4, 5)

=end pod

sub splat (@t) {
    return (gather @t.deepmap(*.take)).list;
}

splat(['a', ['b',['c','d'], 'e']]).perl.say;

# vim: expandtab shiftwidth=4 ft=perl6
