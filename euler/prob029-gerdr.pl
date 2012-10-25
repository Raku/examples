use v6;

# compute number of unique powers a**b with bases \a in range 2..A
# and exponents \b in range 2..B

sub count-naively(Int \A, Int \B --> Int) {
	+(2..A X=> 2..B).classify({ .key ** .value })
}

sub count-smartly(Int \A, Int \B --> Int) {
	# uses the same algorithm as polettix' solution

	my %seen-bases;
	my $seen-values = [+] gather {

		# visit bases which are powers of preceeding ones
		for 2..sqrt(A).Int -> \root {
			next if %seen-bases{root};

			my %seen-exponents;
			my @powers = root, * * root ...^ * > A;

			for @powers Z 1..* -> \base, \exp {
				next if %seen-bases{base};

				# mark powers of \base according to their exponent
				# relative to \root
				%seen-exponents{(2..B) >>*>> exp} = True xx *;

				# avoid double-counting
				%seen-bases{base} = True;
			}

			take +%seen-exponents;
		}

	}

	# without duplicates, the result would be (A - 1) * (B - 1)
	(A - 1 - %seen-bases) * (B - 1) + $seen-values
}

sub bench(|) {
	my \start = now;
	my \result = callsame;
	my \end = now;
	return result, round (end - start) * 1000;
}

sub MAIN(Int $A = 100, Int $B = 100, Bool :$verify) {
	&count-smartly.wrap(&bench);
	&count-naively.wrap(&bench);

	printf "got %u [%ums]\n", count-smartly $A, $B;
	printf "expected %u [%ums]\n", count-naively $A, $B if $verify;
}
