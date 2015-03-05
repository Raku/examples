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

=begin pod

=TITLE Distances in Trees

=AUTHOR grondilu

L<http://rosalind.info/problems/nwck/>

Sample input

    (cat)dog;
    dog cat

    (dog,cat);
    dog cat

Note: a trailing newline is necessary in the input data so that the input is
divisible by three.

Sample output

    1 2


=end pod

    }
    take $climbs + $descents;
}

# vim: expandtab shiftwidth=4 ft=perl6
