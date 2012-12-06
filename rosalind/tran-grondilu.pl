use v6;

given $*IN.slurp {
    my @dna;
    for m:g/ '>Rosalind_' <.digit>**4 \n ( <[ACGT\n]>+ ) / {
        push @dna, $_[0].subst: "\n", '', :g;
    }
    my ($transitions, $transversions);
    for @dna[0].comb Z @dna[1].comb -> $a, $b {
        next unless $a ne $b;
        if ($a eq 'A'|'G' and $b eq 'G'|'A') or ($a eq 'C'|'T' and $b eq 'C'|'T') {
            $transitions++
        } else {
            $transversions++
        }
    }
    say $transitions/$transversions;
}

# vim: ft=perl6
