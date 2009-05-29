# The Computer Language Benchmarks Game
# 
# Based on the submission for Perl 5.
# contributed by Daniel carrera
#
# USAGE: perl6 k-nucleotide.p6.pl < k-nucleotide.input

# Read FASTA file from stdin and extract DNA sequence THREE.
my $sequence = '';
my $lines;
while $*IN.get -> $line {
	last if ($line.substr(0,6) eq '>THREE');
}
while $*IN.get -> $line {
	last if ($line.substr(0,1) eq '>');
	$sequence = $sequence ~ lc $line.subst(/\n/,'');
}

# Count nucleotide sequences
my $len = $sequence.chars;
my (@keys,%table,$sum,$frame_size);
for 1..2 -> $frame_size {
	%table = ();
	update_hash($frame_size);

	# Print.
	$sum = $len - $frame_size + 1;
	for %table.sort: {$^b.value <=> $^a.value||$^a.key leg $^b.key} {
		printf "%s %.3f\n", .key, .value*100/$sum;
	}
	print "\n";
}

for <ggt ggta ggtatt ggtattttaatt ggtattttaatttatagt> -> $seq {
	%table = ();
	update_hash($seq.chars);
	printf "%3d\t$seq\n", (%table{$seq} || 0);
}

# Procedure to update a hashtable of k-nucleotide keys and count values
# for a particular reading-frame.
sub update_hash($frame_size) {
	for 0..($len - $frame_size) -> $i {
		%table{$sequence.substr($i,$frame_size)}++;
	}
}



