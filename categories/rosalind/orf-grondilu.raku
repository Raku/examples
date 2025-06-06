use v6;

=begin pod

=TITLE Open Reading Frames

=AUTHOR L. Grondin

L<http://rosalind.info/problems/orf/>

Sample input

    >Rosalind_99
    AGCCATGTAGCTAACTCAGGTTACATGGGGATGACCCCGCGACTTGGATTAGAGTCTCTTTTGGAATAAGCCTGAATGATCCGAGTAGCATCTCAG

Sample output

    MLLGSFRLIPKETLIQVAGSSPCNLS
    M
    MGMTPRLGLESLLE
    MTPRLGLESLLE

=end pod

constant DNA-codon = Hash.new: <
    TTT F      CTT L      ATT I      GTT V
    TTC F      CTC L      ATC I      GTC V
    TTA L      CTA L      ATA I      GTA V
    TTG L      CTG L      ATG M      GTG V
    TCT S      CCT P      ACT T      GCT A
    TCC S      CCC P      ACC T      GCC A
    TCA S      CCA P      ACA T      GCA A
    TCG S      CCG P      ACG T      GCG A
    TAT Y      CAT H      AAT N      GAT D
    TAC Y      CAC H      AAC N      GAC D
    TAA Stop   CAA Q      AAA K      GAA E
    TAG Stop   CAG Q      AAG K      GAG E
    TGT C      CGT R      AGT S      GGT G
    TGC C      CGC R      AGC S      GGC G
    TGA Stop   CGA R      AGA R      GGA G
    TGG W      CGG R      AGG R      GGG G
>;

my $default-input = "AGCCATGTAGCTAACTCAGGTTACATGGGGATGACCCCGCGACTTGGATTAGAGTCTCTTTTGGAATAAGCCTGAATGATCCGAGTAGCATCTCAG";

sub revc($dna) {
    $dna.comb.reverse.join.trans:
    [<A C T G>] => [<T G A C>]
}

sub orf($dna) {
    my %match;
    my @match = (gather for $dna, revc $dna {
        take .match: rx/ ATG [ <[ACGT]>**3 ]*? <before TAA|TAG|TGA> /, :overlap;
    })>>.list.flat;

    %match{
        [~] map { DNA-codon{$_} }, .match: rx/ <[ACGT]>**3 /, :g
    }++ for @match;

    return %match.keys.sort;
}

sub MAIN(Str $input = $default-input) {
    .say for orf $input;
}

# vim: expandtab shiftwidth=4 ft=perl6
