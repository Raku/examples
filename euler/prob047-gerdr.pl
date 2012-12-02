use v6;
use NativeCall;

sub factors(int $n) returns int is native('./prob047-gerdr') { * }

sub MAIN(Int $N = 4) {
	my int $n = 2;
	my int $i = 0;

	while $i != $N {
		$i = factors($n) == $N ?? $i + 1 !! 0;
		$n = $n + 1;
	}

	say $n - $N;
}
