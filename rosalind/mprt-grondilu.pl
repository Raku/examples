use v6;

my $N-glycosylation = rx / N <-[P]> <[ST]> <-[P]> /;
for $*IN.lines -> $id {
    my $fasta = qqx{wget -O - -q "http://www.uniprot.org/uniprot/$id.fasta"};
    given join '', grep /^ <.alpha>+ $/, $fasta.split: "\n" {
        if $N-glycosylation {
            say $id;
            say gather for m:overlap/$N-glycosylation/ { take .from + 1}
        }
    }
}

# vim: ft=perl6
