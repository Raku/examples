use v6;
# Specification:
#   P14 (*) Duplicate the elements of a list.
# Example:
# > say ~dupli(<a b c c d>);
# a a b b c c c c d d


sub dupli(@l) {
	return @l.map({$_, $_});
}
say ~dupli(<a b c c d>);

