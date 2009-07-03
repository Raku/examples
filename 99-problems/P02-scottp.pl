# NOTE: Experimenting with documentation for tutorials / help
use v6;

# a. One line example
#	<> can be used to generate an array, similar to perl 5 - qw<a b c d>
#	[] is used to select the element number
#	* means the number of elements
#	say is like print to stdout with a new line
#	.say can be called as everything is an object
<A B C D E F>[* - 2].say;

# b. Subroutine example
#	@l lists can be passed in as parameters - no need to use references
#	.elems - is the number of elements, this time called on the object
#	say called in procedure form
sub my_but_last (@l) {
	return @l[@l.elems - 2];
}
say my_but_last(<a b c d>);

=begin

=head1 NAME

P02 - Find the last but one box of a list.

=head1 LISP

 P02 (*) Find the last but one box of a list.
 Example:
 * (my-but-last '(a b c d))
 (C D)

=cut
=end

