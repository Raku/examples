use v6;

=begin pod

=TITLE Matching Random Motifs

L<http://rosalind.info/problems/rstr/>

Sample input

    90000 0.6
    ATAGCCGA

Sample output

    0.689

=end pod

my @data = $*IN.lines;
my ($N, $gc-content) = @data.shift.split: " ";
my $dna = @data.shift;

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars * [*] map { $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content) }, $dna.comb
}

printf "%.3f",  1 - exp ($N * log(1-prob :$dna, :$gc-content));

# vim: expandtab shiftwidth=4 ft=perl6
