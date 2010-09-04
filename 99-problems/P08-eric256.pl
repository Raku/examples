use v6;


#p8
#
sub compress (@in) {
	my @return;
	my $last;
	for @in -> $i {
		if ($i ne $last) {
			@return.push($i);
			$last = $i;
		}
	}
	return @return;
}

compress(<a a a a b c c a a d e e e e>).perl.say;


