use v6;

=begin pod

=TITLE Finding a Protein Motif

=AUTHOR L. Grondin

L<http://rosalind.info/problems/mprt/>

Sample input

    A2Z669
    B5ZC00
    P07204_TRBM_HUMAN
    P20840_SAG1_YEAST

Sample output

    B5ZC00
    85 118 142 306 395
    P07204_TRBM_HUMAN
    47 115 116 382 409
    P20840_SAG1_YEAST
    79 109 135 248 306 348 364 402 485 501 614

=end pod

my @default-data = qw{
    A2Z669
    B5ZC00
    P07204_TRBM_HUMAN
    P20840_SAG1_YEAST
};

sub MAIN($input-file = Nil) {
    my @input = $input-file ?? $input-file.IO.lines !! @default-data;
    my $N-glycosylation = rx / N <-[P]> <[ST]> <-[P]> /;
    my $base-path = $*PROGRAM-NAME.IO.dirname;
    for @input -> $id {
        my $fasta-name = $*SPEC.catdir($base-path, "$id.fasta");
        my $fasta = $fasta-name.IO.e
            ?? $fasta-name.IO.slurp
            !! qqx{wget -O - -q "http://www.uniprot.org/uniprot/$id.fasta"};
        given join '', grep /^ <.alpha>+ $/, $fasta.lines {
            when $N-glycosylation {
                say $id;
                my @arr = gather for m:overlap/$N-glycosylation/ { take .from + 1}
                say "{@arr}"
            }
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
