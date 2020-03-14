use v6;

=begin pod

=TITLE Counting DNA Nucleotides

=AUTHOR gerdr

L<http://rosalind.info/problems/dna/>

Sample input

    AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC

Sample output

    20 12 17 21

=end pod

my $default-input = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC";

sub MAIN($input = $default-input) {
    "{<A C G T>.map({ +$input.comb(/$_/) })}".say;
}

# vim: expandtab shiftwidth=4 ft=perl6
