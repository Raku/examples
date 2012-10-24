use v6;

sub d(Int \n) {
	my $sum = 1;
	my \sqrt-n = sqrt n;

	for 2..Int(sqrt-n) -> \a {
		my \b = n div a;
		$sum += a + b if a * b == n;
	}

	sqrt-n ~~ Int ?? $sum - sqrt-n !! $sum
}

my $sum = 0;

for 1..10_000 -> \a {
	my \b = d(a);
	$sum += a + b if a < b and d(b) == a;
}

say $sum;
