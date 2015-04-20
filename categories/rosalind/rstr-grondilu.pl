use v6;

=begin pod

=TITLE Matching Random Motifs

=AUTHOR L. Grondin

L<http://rosalind.info/problems/rstr/>

Sample input

    90000 0.6
    ATAGCCGA

Sample output

    0.689

=end pod

my @default-input = ("90000 0.6", "ATAGCCGA");

sub MAIN($input-file = Nil) {
    my @data = $input-file ?? $input-file.IO.lines !! @default-input;
    my ($N, $gc-content) = @data.shift.split: " ";
    my $dna = @data.shift;

    my $result = 1 - exp ($N * log(1-prob :$dna, :$gc-content));
    say $result.fmt("%.3f");
}

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars * [*] map {
        $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content)
    }, $dna.comb
}


# vim: expandtab shiftwidth=4 ft=perl6
