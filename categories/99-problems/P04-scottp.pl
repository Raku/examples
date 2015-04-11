use v6;

=begin pod

=TITLE P04 - Find the number of elements of a list

=AUTHOR Scott Penrose

Specification:

    P04 - Find the number of elements of a list

=end pod

# a. The .elems method:
#   <> can be used to generate an array, similar to perl 5 - qw<a b c d>
#   .elems can be called as the array create an object
#   .say can be called on the returned object
<a b c d>.elems.say;

# b. The unary + operator:
#   + coerces its operand to numeric context
#   a Positional in numeric context returns the count of its elements
say +<a b c d>;
say +<a b c d>[0,2]; # works on slices too

# vim: expandtab shiftwidth=4 ft=perl6
