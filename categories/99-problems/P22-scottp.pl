use v6;

=begin pod

=TITLE P22 - Create a list containing all integers within a given range.

=AUTHOR Scott Penrose

=head1 Specification

   P22 (*) Create a list containing all integers within a given range.
           If first argument is smaller than second, produce a list in
           decreasing order.

=head1 Examples

    > say ~range(4, 9);
    4 5 6 7 8 9

=end pod

# a. Simple version - but only works in order
say ~list(4 .. 9);

# b. Try reverse
#       Simple check on arguments
#       Then just reverse the forward version of the list
sub range($a, $b) {
    if ($a > $b) {
        return list($b .. $a).reverse;
    }
    return list($a .. $b);
}
say ~range(4, 9);
say ~range(7, 2);

# vim: expandtab shiftwidth=4 ft=perl6
