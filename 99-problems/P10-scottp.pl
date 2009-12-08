#Pack consecutive duplicates of list elements into sublists.
#If a list contains repeated elements they should be placed in separate sublists.
#
#Example:
#* (pack '(a a a a b c c a a d e e e e))
# ((A A A A) (B) (C C) (A A) (D) (E E E E))

use v6;
my @l = <a a a a b c c a a d e e e e>;
sub packit (@in) {
	my @out;
	my $last = shift @in;
	my $count = 1;
	for @in -> $t {
		if ($last eq $t) {
			$count++;
		}
		else {
			push @out, [$count, $last];
			$last = $t;
			$count = 1;
		}
	}
	push @out, [$count, $last];
	return @out;
}
say ~@l;
say packit(@l).perl;

