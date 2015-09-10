use v6;

=begin pod

=TITLE P02 - Find the last but one box of a list.

=AUTHOR Scott Penrose

Specification:
    P02 - Find the last two elements of a list.

=head1 Example:

    > say ~my_but_last(<A B C D>);
    C D

=head1 LISP

    P02 (*) Find the last but one box of a list.
    Example:
    * (my-but-last '(a b c d))
    (C D)

=end pod

# a. One line example
#   <> can be used to generate an list, similar to perl 5 - qw<a b c d>
#   [] is used to slice a list or array and returns a list
#   * means the number of elements
#   say is like print to stdout with a new line
#   .say can be called as everything is an object
#   we pass a list to [] to ask for the second-last and last elements
"{<A B C D E F>.[*-2,*-1]}".say;

# b. Subroutine example
#   @l lists can be passed in as parameters - no need to use references
#   .elems - is the number of elements, this time called on the object
#   say called in procedure form
#   This time we use the range operator .. to create a Range object
sub my_but_last (@l) {
    return @l[@l.elems-2 .. @l.elems-1];
}

#   ~ operator stringifies the result: ~<a b> goes to 'a b'
say ~my_but_last(<a b c d>);

# vim: expandtab shiftwidth=4 ft=perl6
