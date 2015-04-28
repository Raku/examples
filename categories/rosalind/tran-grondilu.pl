use v6;

=begin pod

=TITLE Transitions and Transversions

=AUTHOR L. Grondin

L<http://rosalind.info/problems/tran/>

Sample input

    >Rosalind_0209
    GCAACGCACAACGAAAACCCTTAGGGACTGGATTATTTCGTGATCGTTGTAGTTATTGGA
    AGTACGGGCATCAACCCAGTT
    >Rosalind_2200
    TTATCTGACAAAGAAAGCCGTCAACGGCTGGATAATTTCGCGATCGTGCTGGTTACTGGC
    GGTACGAGTGTTCCTTTGGGT

Sample output

    1.21428571429

=end pod

my $default-input = q:to/END/;
    >Rosalind_0209
    GCAACGCACAACGAAAACCCTTAGGGACTGGATTATTTCGTGATCGTTGTAGTTATTGGA
    AGTACGGGCATCAACCCAGTT
    >Rosalind_2200
    TTATCTGACAAAGAAAGCCGTCAACGGCTGGATAATTTCGCGATCGTGCTGGTTACTGGC
    GGTACGAGTGTTCCTTTGGGT
    END

sub MAIN($input-file = Nil) {
    my $input = $input-file ?? $input-file.IO.slurp !! $default-input;
    given $input {
        my @dna;
        for m:g/ '>Rosalind_' <.digit>**4 \n ( <[ACGT\n]>+ ) / {
            push @dna, $_[0].subst: "\n", '', :g;
        }
        my ($transitions, $transversions);
        for (@dna[0].comb Z @dna[1].comb).flat -> $a, $b {
            next unless $a ne $b;
            if "$a$b" eq any <AG GA CT TC> { $transitions++ }
            else { $transversions++ }
        }
        say ($transitions/$transversions).fmt("%0.11f");
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
