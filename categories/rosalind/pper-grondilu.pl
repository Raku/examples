use v6;

=begin pod

=TITLE Partial Permutations

L<http://rosalind.info/problems/pper/>

Sample input

    21 7

Sample output

    51200

=end pod

sub pper($n, $k) { [*] $n-$k+1 .. $n }
say pper(| $*IN.get.split: " ") % 1_000_000;

# vim: expandtab shiftwidth=4 ft=perl6
