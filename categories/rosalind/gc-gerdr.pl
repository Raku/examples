use v6;

=begin pod

=TITLE Computing GC Content

=AUTHOR gerdr

L<http://rosalind.info/problems/gc/>

Sample input

    >Rosalind_6404
    CCTGCGGAAGATCGGCACTAGAATAGCCAGAACCGTTTCTCTGAGGCTTCCGGCCTTCCC
    TCCCACTAATAATTCTGAGG
    >Rosalind_5959
    CCATCGGTAGCGCATCCTTAGTCCAATTAAGTCCCTATCCAGGCGCTCCGCCGAAGGTCT
    ATATCCATTTGTCAGCAGACACGC
    >Rosalind_0808
    CCACCCTCGTGGTATGGCTAGGCATTCAGGAACCGGAGAACGCTTCAGACCAGCCCGGAC
    TGGGAACCTGCGGGCAGTAGGTGGAAT

Sample output

    Rosalind_0808
    60.919540

=end pod

grammar FASTA {
    token TOP { ^ \n* <DNA-string>+ }
    token DNA-string { '>' (\N+) \n (<[ACGT\n]>+) }
}

my $actions = class {
    method TOP($/) {
        make $<DNA-string>>>.ast
    }

    method DNA-string($/) {
        make [~$0, 100 * +.comb(/<[GC]>/) / +.comb(/<[ACGT]>/)]
        given ~$1
    }
};

my $default-input = q:to/END/;
    >Rosalind_6404
    CCTGCGGAAGATCGGCACTAGAATAGCCAGAACCGTTTCTCTGAGGCTTCCGGCCTTCCC
    TCCCACTAATAATTCTGAGG
    >Rosalind_5959
    CCATCGGTAGCGCATCCTTAGTCCAATTAAGTCCCTATCCAGGCGCTCCGCCGAAGGTCT
    ATATCCATTTGTCAGCAGACACGC
    >Rosalind_0808
    CCACCCTCGTGGTATGGCTAGGCATTCAGGAACCGGAGAACGCTTCAGACCAGCCCGGAC
    TGGGAACCTGCGGGCAGTAGGTGGAAT
    END

sub MAIN($input-file = Nil) {
    my $input = $input-file ?? $input-file.IO.slurp !! $default-input;

    FASTA.parse($_, :$actions).ast.sort(*.[1]).[*-1] ~ '%' ==> say()
        given $input;
}

# vim: expandtab shiftwidth=4 ft=perl6
