use v6;

# Specification:
#   P07 (**) Flatten a nested array structure.
#       Transform an array, possibly holding arrays as elements into a `flat'
#       list by replacing each array with its elements (recursively).
# Example:
# > splat([1,[2,[3,4],5]]).perl.say;
# (1, 2, 3, 4, 5)


sub splat (@t) { 
	my @return = [];
	for @t -> $i {
		if ($i.isa(Array)) {
			@return.push( splat($i) );
		} else {
			@return.push( $i );
		}
	}
	return @return;
}

splat(['a', ['b',['c','d'], 'e']]).perl.say;



