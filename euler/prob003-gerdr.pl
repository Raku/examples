use v6;

sub largest-prime-factor($n is copy) {
	my @primes;
	for 2, 3, *+2 ... * -> $p {
		next if $p %% any @primes.grep({ $_ * $_ <= $p or last});
		@primes.push($p);
		while $n %% $p {
			$n div= $p;
			return $p if $p >= $n;
		}
	}
}

say largest-prime-factor(600851475143);
