use v6;

# this program takes quite a few minutes on my machine

my Int multi sub collatz(Int $n where * %% 2) { $n div 2;   }
my Int multi sub collatz(Int $n             ) { 3 * $n + 1; }

my Int sub get-length(Int $n)  {
	state Int %length{Int} = 1 => 1;
	my $result = %length{$n} // 1 + get-length collatz $n;
	%length{$n} = $result;
	$result;
}

my $max = 0;
my $start = 0;
for 1 ..^ 1_000_000 -> $n {
	say $n; #just for progress
	my $length = get-length $n;

	if $length > $max {
		$start = $n;
		$max = $length;
	}
}

say $max;
say $start;
