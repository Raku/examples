use v6;

# NOTE: Experimenting with documentation for tutorials / help

# a. One line example:
#	<> can be used to generate an array, similar to perl 5 - qw<a b c d>
#	[] is used to select the element number
#	* means the number of elements
#	say is like print to stdout with a new line
#	.say can be called as everything is an object
<A B C D E F>[* - 1].say;

# b. Subroutine example
#	@l lists can be passed in as parameters - no need to use references
#	.elems - is the number of elements, this time called on the object
#	say called in procedure form
sub my_last(@l) {
	return @l[@l.elems - 1];
}
say my_last(<A B C D>);

# c. Pop like perl5
#	pop the last element off, which also returns it
#	say either way
say <X Y Z>.pop;
<X Y Z>.pop.say;

=begin

=head1 NAME

P01 - Find the last box of a list.

=head1 LISP

 P01 (*) Find the last box of a list.
 Example:
 * (my-last '(a b c d))
 (D)

=cut
=end

