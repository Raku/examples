use v6;

sub largest-prime-factor($n is copy) {
	for 2, 3, *+2 ... * {
		next unless $n %% $_ and .is-prime;
		repeat while $n %% $_ {
			$n div= $_
		}
		return $_ if $_ > $n;
	}
}

say largest-prime-factor(600_851_475_143);
