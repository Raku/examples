use v6;

=begin pod

=TITLE Finding a Spliced Motif

L<http://rosalind.info/problems/sseq/>

Sample input

    ACGTACGTGACG
    GTA

Sample output

    3 8 10

=end pod

my @default-data = qw{ACGTACGTGACG GTA};

sub MAIN($input-file = Nil) {
    my ($dna, $search) = $input-file ?? $input-file.IO.lines !! @default-data;

    my $pos = 0;
    say gather for $search.comb -> $c {
        $dna ~~ m:c($pos)/$c/;
        take $pos = $/.from + 1;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
