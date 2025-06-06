use v6;

=begin pod

=TITLE P03 - Find the K'th element of a list.

=AUTHOR Scott Penrose

Specification:
  P03 - Find the K'th element of a list.
        The first element in the list is number 1.

=head1 Example:

    > say element_at <a b c d e>,3;
    c

=head1 LISP

    P03 (*) Find the K'th element of a list.
    The first element in the list is number 1.
    Example:
    * (element-at '(a b c d e) 3)
    C

=end pod

# a. One line example:
#   <> can be used to generate an array, similar to perl 5 - qw<a b c d>
#   [] is used to select the element number
#   note that the first element's index is 0, so we must subtract 1
#   say is like print to stdout with a new line
#   .say can be called as a method since everything is an object
<A B C D E F>[3 - 1].say;

# b. Subroutine example
#   @l lists can be passed in as parameters - no need to use references
#   $n a scalar location in the array
#       Note you can pass this in after an array because the array
#       is not slurped in like it would be in Perl 5 !
#   .elems - is the number of elements, this time called on the object
#   say called in procedure form
sub element_at (@l, $n) {
    return @l[$n - 1];
}
say element_at <a b c d e>,3;

# vim: expandtab shiftwidth=4 ft=perl6
