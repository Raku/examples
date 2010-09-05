use v6;

# Specification:
#   P15 (**) Replicate the elements of a list a given number of times.
# Example:
# > say ~repli <a b c>,3;
# a a a b b b c c c


sub repli(@l,$n) {
	return @l.map({$_ xx $n});
}

say ~repli <a b c>,3;
