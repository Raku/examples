use v6;


# p7
sub splat (@t) { 
	my @return;
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



