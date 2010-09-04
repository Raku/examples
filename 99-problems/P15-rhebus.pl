# Replicate the elements of a list a given number of times.
# Example:
# * (repli '(a b c) 3)
#   (A A A B B B C C C)

use v6;
sub repli(@l,$n) {
	return @l.map({$_ xx $n});
}
say repli(<a b c>,3);

