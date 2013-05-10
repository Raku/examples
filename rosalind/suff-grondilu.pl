use v6;

my $dna = get;
sub suffixes(Str $str) { map *.flip, [\~] $str.flip.comb }
sub suffix-tree(@a) {
    if (@a == 0) { [] }
    elsif (@a == 1) { return hash @a[0] => [] }
    else {
	return hash gather for @a.classify(*.substr(0, 1)) {
	    my $subtree = suffix-tree([ grep *.chars, map *.substr(1), .value[] ]);
	    if $subtree.elems == 1 {
		my $pair = $subtree.pick;
		take .key ~ $pair.key => $pair.value;
	    } else {
		take .key => $subtree;
	    }
	}
    }
}

sub show-edges($tree) {
    return if $tree.elems == 0;
    for $tree[] {
	say .key;
	show-edges .value;
    }
}

my $tree = suffix-tree(suffixes($dna));

show-edges $tree;


# vim: ft=perl6
