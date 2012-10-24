use v6;

sub first-triple(\N) {
	for 1..(N div 3) -> \a {
		my \u = N * (N - 2 * a);
		my \v = 2 * (N - a);

		if u %% v {
			my \b = u div v;
			my \c = N - a - b;
			return a, b, c;
		}
	}
}

say [*] first-triple(1000);
