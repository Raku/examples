use v6;

<A C G T>.map({ +.comb(/$^symbol/) }).say given slurp;
=begin pod

=TITLE Counting DNA Nucleotides

L<http://rosalind.info/problems/dna/>

Sample input

    AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC

Sample output

    20 12 17 21

=end pod


# vim: expandtab shiftwidth=4 ft=perl6
