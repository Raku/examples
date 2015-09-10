use v6;

=begin pod

=TITLE P01 - Find the last box of a list.

=AUTHOR Scott Penrose

=head1 LISP

    P01 (*) Find the last box of a list.
    Example:
    * (my-last '(a b c d))
    (D)

Note that, in LISP-speak, the last "box" is the last one-element sublist of
the list. In perl6, a single element can generally be used as a list and
vice versa; as a result, this example does not distinguish between a single
element and a list containing a single element.

=head1 Example:

    > say my_last <a b c d>;
    d

=end pod

# a. One line example:
#       <> can be used to generate an array, similar to perl 5 - qw<a b c d>
#       [] is used to select the element number
#       * means the number of elements
#       say is like print to stdout with a new line
#       .say can be called as everything is an object
<A B C D E F>[* - 1].say;

# b. Subroutine example
#       @l lists can be passed in as parameters - no need to use references
#       .elems - is the number of elements, this time called on the object
#       say called in procedure form
sub my_last(@l) {
        return @l[@l.elems - 1];
}
say my_last(<A B C D>);

# c. Pop like perl5
#       pop the last element off, which also returns it
#       say either way
say <X Y Z>.Array.pop;
<X Y Z>.Array.pop.say;

# vim: expandtab shiftwidth=4 ft=perl6
