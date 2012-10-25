use v6;

# same algorithm as polettix' solution

# range of bases
constant A = 2..100;

# range of exponents
constant B = 2..100;

my %seen-bases;
my $seen-values = [+] gather {

	# visit bases which are powers of preceeding ones
	for A[0] .. sqrt(A[*-1]).Int -> \root {
		next if %seen-bases{root};

		my %seen-exponents;
		my @powers = root, * * root ...^ * > A[*-1];

		for @powers Z 1..* -> \base, \exp {
			next if %seen-bases{base};

			# mark powers of \base according to their exponent
			# relative to \root
			%seen-exponents{B.map(* * exp)} = True...*;

			# avoid double-counting
			%seen-bases{base} = True;
		}

		take +%seen-exponents;
	}

}

# without duplicates, the result would be A * B
say (A - %seen-bases) * B + $seen-values;
