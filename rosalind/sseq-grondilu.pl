use v6;
my ($dna, $search) = $*IN.lines;

my $pos = 0;
say gather for $search.comb -> $c {
    $dna ~~ m:c($pos)/$c/;
    take $pos = $/.from + 1;
}

# vim: ft=perl6
