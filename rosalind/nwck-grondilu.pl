use v6;
say gather for lines[] -> $newick, $taxa, $ {
    my ($a, $b) = $taxa.split: ' ';
    my @token = $newick.comb: rx/ <.ident>+ | <[(),]> /;
    Mu while @token.shift ne $a|$b;
    my ($climbs, $descents) = 0 xx 2;
    for @token {
	last if $_ eq $a or $_ eq $b;
	if /< , ) >/ {
	    if $descents > 0 { $descents-- }
	    else { $climbs++ }
	}
	if /< , ( >/ { $descents++ }
    }
    take $climbs + $descents;
}

# vim: ft=perl6
