use v6;

# Specification:
#   P06 (*) Find out whether a list is a palindrome.
#   A palindrome can be read forward or backward; e.g. <x a m a x>.

# Create a list palindrome
my @l = <A B C B A>;
# Reverse the list (see P05)
# Then compare it
# 	==	This will comare two lists, and return true if they contain the same
# 	elements - but it does not care about the order of the elements.
# 	eq  This will turn the list into a string, and compare those
if (@l eq @l.reverse) {
	say @l, ' is a palindrome';
}
else {
	say @l, ' is not a palindrome';
}

# ORIGINAL LISP SPECIFICATION

=begin pod

=head1 NAME

P06 - Find out whether a list is a palindrome.

=head1 LISP

 P06 (*) Find out whether a list is a palindrome.
 A palindrome can be read forward or backward; e.g. (x a m a x).

=end pod

