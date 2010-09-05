use v6;

# Specification:
#   P07 (**) Flatten a nested array structure.
#       Transform an array, possibly holding arrays as elements into a `flat'
#       list by replacing each array with its elements (recursively).
# Example:
# > splat([1,[2,[3,4],5]]).perl.say;
# (1, 2, 3, 4, 5)


# We use the gather/take structure.
#   A gather block builds a list using take statements. Each take adds one
#       element to the list. The gather block returns the complete list.
#   A gather block operates with dynamic scope, so the take statements may be
#       in another subroutine.
# for @t -> $t
#   iterates over @t, placing each element in turn in $t
# ~~ is the smart match operator. Here we use it to check the type of $t.
#    we could have said $t.isa(Array) instead.

sub _splat(@t) {
    for @t -> $t {
        if $t ~~ Array { _splat($t) }
        else           { take $t }
    }
}

sub splat (@t) { gather _splat(@t) }

splat([1, [2,[3,4], 5]]).perl.say;

# vim:ft=perl6
