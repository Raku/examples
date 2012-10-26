use v6;

# compute number of unique powers a**b with bases \a in range 2..A
# and exponents \b in range 2..B

sub count-naively(Int \A, Int \B --> Int) {
	+(2..A X=> 2..B).classify({ .key ** .value })
}

sub count-smartly(Int \A, Int \B --> Int) {
	my (%powers, %count);

	# find bases which are powers of a preceeding root base
	# store decomposition into base and exponent relative to root
	for 2..Int(sqrt A) -> \a {
		for 2..* Z a**2, a**3, a**4 ...^ * > A -> \e, \p {
			%powers{a} //= (a) => 1;
			%powers{p} //= (a) => e;
		}
	}

	# count duplicates
	for %powers.values -> \p {
		for 2..B -> \e {
			# raise to power e
			# classify by root and relative exponent
			++%count{p.key => p.value * e}
		}
	}

	# add +%count as one of the duplicates needs to be kept
	return (A - 1) * (B - 1) + %count - [+] %count.values;
}

sub bench(|) {
	my \start = now;
	my \result = callsame;
	my \end = now;
	return result, round (end - start) * 1000;
}

multi MAIN(Int $N, Bool :$verify) {
	nextwith($N, $N, :$verify)
}

multi MAIN(Int $A = 100, Int $B = 100, Bool :$verify) {
	&count-smartly.wrap(&bench);
	&count-naively.wrap(&bench);

	printf "got %u [%ums]\n", count-smartly $A, $B;
	printf "expected %u [%ums]\n", count-naively $A, $B if $verify;
}
