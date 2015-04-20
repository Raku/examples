use v6;

=begin pod

=TITLE Creating a Character Table from Genetic Strings

=AUTHOR L. Grondin

L<http://rosalind.info/problems/cstr/>

Sample input

    ATGCTACC
    CGTTTACC
    ATTCGACC
    AGTCTCCC
    CGTCTATC

Sample output

    10110
    10100

=end pod

my @default-data = qw:to/END/;
    ATGCTACC
    CGTTTACC
    ATTCGACC
    AGTCTCCC
    CGTCTATC
    END

sub MAIN($input-file = Nil) {
    my @input = $input-file ?? $input-file.IO.lines !! @default-data;
    my @dna = map { [.comb] }, @input;
    my @c = @dna[0][];

    for ^@c -> $c {
        my @line = map { +so .[$c] eq @c[$c] }, @dna;
        say @line.join if 1 < ([+] @line) < @dna-1;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
