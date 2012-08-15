use v6;

# Specification:
#   P08 (**) Eliminate consecutive duplicates of list elements.
#       If a list contains repeated elements they should be replaced with a
#       single copy of the element. The order of the elements should not be
#       changed.
#
# Example:
# > say ~compress(<a a a a b c c a a d e e e e>)
# a b c a d e


sub compress (@in) {
	my @return;
	my $last;
	for @in -> $i {
# The FIRST { } will remove the 'use of uninitialised value of type Any in
# String context' warning in rakudo, but niecza hasn't implemented it as of
# Aug 15 2012 so I'll leave it here, but commented out.
#        FIRST { $last = '' }
		if ($i ne $last) {
			@return.push($i);
			$last = $i;
		}
	}
	return @return;
}

compress(<a a a a b c c a a d e e e e>).perl.say;


