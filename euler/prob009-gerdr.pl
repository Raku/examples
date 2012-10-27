use v6;

# Let (a, b, c) be a pythagorean triple
#
#	a < b < c
#	a² + b² = c²
#
# For N = a + b + c it follows
#
#	b = N·(N - 2a) / 2·(N - a)
#	c = N·(N - 2a) / 2·(N - a) + a²/(N - a)
#
# which automatically meets b < c.
#
# The condition a < b gives the constraint
#
#	a < (1 - 1/√2)·N
#

sub triples(\N) {
	for 1..Int((1 - sqrt(0.5)) * N) -> \a {
		my \u = N * (N - 2 * a);
		my \v = 2 * (N - a);

		# check if b = u/v is an integer
		# if so, we've found a triple
		if u %% v {
			my \b = u div v;
			my \c = N - a - b;
			take $(a, b, c);
		}
	}
}

say [*] .list for gather triples(1000);
