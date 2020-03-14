use v6;

=begin pod

=TITLE Finding a Spliced Motif

=AUTHOR L. Grondin

L<http://rosalind.info/problems/sseq/>

Sample input

    ACGTACGTGACG
    GTA

Sample output

    3 4 5

=end pod

my @default-data = qw{ACGTACGTGACG GTA};

sub MAIN($input-file = Nil) {
    my ($dna, $search) = $input-file ?? $input-file.IO.lines !! @default-data;

    my $pos = 0;
    my @arr = gather for $search.comb -> $c {
        $dna ~~ m:c($pos)/$c/;
        take $pos = $/.from + 1;
    }
    say "{@arr}"
}

# vim: expandtab shiftwidth=4 ft=perl6
