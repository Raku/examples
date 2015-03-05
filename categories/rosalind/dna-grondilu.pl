use v6;

=begin pod

=TITLE Counting DNA Nucleotides

=AUTHOR grondilu

L<http://rosalind.info/problems/dna/>

Sample input

    AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC

Sample output

    20 12 17 21

=end pod

say bag(get.comb)<A C G T>;

# vim: expandtab shiftwidth=4 ft=perl6
