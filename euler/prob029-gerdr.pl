use v6;

# same algorithm as polettix' solution

sub count-unique-powers(Int \A, Int \B --> Int) {
	# computes number of unique powers a**b with bases \a in range 2..A
	# and exponents \b in range 2..B

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
				%seen-exponents{(2..B).map(* * exp)} = True...*;

				# avoid double-counting
				%seen-bases{base} = True;
			}

			take +%seen-exponents;
		}

	}

	# without duplicates, the result would be (A - 1) * (B - 1)
	(A - 1 - %seen-bases) * (B - 1) + $seen-values
}

sub MAIN(Int $A = 100, Int $B = 100, Bool :$verify) {
	say 'got ',
		count-unique-powers $A, $B;

	say 'expected ',
		+(2..$A X=> 2..$B).classify({ .key ** .value })
		if $verify;
}
