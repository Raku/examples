use v6;

my $triangle = slurp('triangle.txt');
my @lines = string-to-array($triangle).reverse;

# reduce the triangle by adding up the lines until only one line with one
# element is left; then print it.
say @lines.reduce: &add-maxima;

# this function assumes the shorter and longer array to be consecutive lines
# in an reversed triangle. It then adds each of the maxima of consecutive fields
# of the longer array to their shared diagonal neighbour in the shorter array.
sub add-maxima(@longer, @shorter is copy) {
	for 0 .. @longer - 2 -> $i {
		@shorter[$i] += max @longer[$i], @longer[$i + 1];
	}
}

sub string-to-array($string) {
	my @lines = $string.lines;
	@lines .= map(-> $line { $line.comb(/\d+/).item });
}
