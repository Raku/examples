use v6;

=begin pod

=TITLE Counting DNA Nucleotides

=AUTHOR L. Grondin

L<http://rosalind.info/problems/dna/>

Sample input

    AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC

Sample output

    20 12 17 21

=end pod

my $default-input = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC";

sub MAIN(Str $input = $default-input) {
    say "{bag($input.comb)<A C G T>}";
}

# vim: expandtab shiftwidth=4 ft=perl6
