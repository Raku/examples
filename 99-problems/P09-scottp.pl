use v6;

# Specification:
#   P09 (**) Pack consecutive duplicates of list elements into sublists.
#       If a list contains repeated elements they should be placed in separate
#       sublists.
# Example:
# > pack_dup(<a a a a b c c a a d e e e e>).perl.say
# [["a","a","a","a"],["b"],["c","c"],["a","a"],["d"],["e","e","e","e"]]


my @l = <a a a a b c c a a d e e e e>;
sub packit (@in) {
	my @out;
	my @last = shift @in;
	for @in -> $t {
		if (@last[0] ne $t) {
			push @out, [@last];
			@last = $t;
		}
		else {
			push @last, $t;
		}
	}
	if (@last.elems) {
		push @out, [@last];
	}
	return @out;
}
say ~@l;
say packit(@l).perl;

