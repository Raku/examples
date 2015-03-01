# The Computer Language Benchmarks Game
#
# Based on the submission for Perl 5.
# contributed by Daniel carrera
#
# USAGE: perl6 fasta.p6.pl 1000

constant IM = 139968;
constant IA = 3877;
constant IC = 29573;
constant LINELENGTH = 60;

my $Seed = 42;

my @iub = (	['a', 0.27], ['c', 0.12], ['g', 0.12],
		['t', 0.27], ['B', 0.02], ['D', 0.02],
		['H', 0.02], ['K', 0.02], ['M', 0.02],
		['N', 0.02], ['R', 0.02], ['S', 0.02],
		['V', 0.02], ['W', 0.02], ['Y', 0.02]
);

my @homosapiens = (	['a', 0.3029549426680],
			['c', 0.1979883004921],
			['g', 0.1975473066391],
			['t', 0.3015094502008]
);

my $alu =	'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG' ~
		'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA' ~
		'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT' ~
		'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA' ~
		'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG' ~
		'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC' ~
		'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';

my $n = (@*ARGS[0] || 1000) ;

makeCumulative(@iub);
makeCumulative(@homosapiens);

makeRepeatFasta('ONE', 'Homo sapiens alu', $n*2, $alu);
makeRandomFasta('TWO', 'IUB ambiguity codes', $n*3, @iub);
makeRandomFasta('THREE', 'Homo sapiens frequency', $n*5, @homosapiens);

sub makeCumulative(@genelist is rw) {
	my $cp = 0.0;
	for @genelist -> @gene {
		@gene[1] = $cp += @gene[1];
	}
}

sub makeRepeatFasta($id, $desc, $n, $s) {
	say ">$id $desc";

	my $r = $s.chars;
	my $ss = $s ~ $s ~ $s.substr(0, $n % $r);

	for 0..($n div LINELENGTH)-1 -> $k {
		my $i = $k*LINELENGTH % $r;
		say $ss.substr($i, LINELENGTH);
	}
	if ($n % LINELENGTH) {
		say $ss.substr(*-($n % LINELENGTH));
	}
}

sub makeRandomFasta($id, $desc, $n, @genelist) {
	say ">$id $desc";

	# print whole lines
	for 1 .. ($n div LINELENGTH) {
		say selectRandom(@genelist, LINELENGTH);
	}
	# print remaining line (if required)
	if ($n % LINELENGTH) {
		say selectRandom(@genelist, $n % LINELENGTH);
	}
}

sub selectRandom(@genelist, $length) {
	my @rand = gen_random($length);
	my $seq = '';

	for @rand -> $rand {
		for @genelist -> @gene {
			if ($rand < @gene[1]) { $seq ~= @gene[0]; last; }
		}
	}
	return $seq;
}

sub gen_random($length) {
	map {
		$Seed = ($Seed * IA + IC) % IM;
		$Seed / IM;
	} , 1..$length;
}

