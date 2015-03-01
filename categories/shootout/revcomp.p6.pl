# The Computer Language Benchmarks Game
#	# Based on the submission for Perl 5.
# contributed by Daniel carrera
#
# USAGE: perl6 revcomp.p6.pl < revcomp.input

my ($desc,$seq) = ('','');
while $*IN.get -> $line {
	if $line.match(/^ \>/) {
		print_revcomp();
		$desc = $line;
		$seq = '';
	} else {
		$seq ~= $line;
	}
}
print_revcomp();

sub print_revcomp() {
	return if not $desc;
	say $desc;
	$seq = $seq.flip.trans('wsatugcyrkmbdhvnATUGCYRKMBDHVN' => 'WSTAACGRYMKVHDBNTAACGRYMKVHDBN');

	for ^($seq.chars/60) -> $i {
		say $seq.substr($i*60,60);
	}
}
