use v6;

=begin pod

=TITLE Expected Number of Restriction Sites

=AUTHOR L. Grondin

L<http://rosalind.info/problems/eval/>

Sample input

    10
    AG
    0.25 0.5 0.75

Sample output

    0.422 0.563 0.422

=end pod

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars *
    [*] map { $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content) }, $dna.comb
}

my @data = ('10', 'AG', '0.25 0.5 0.75');
my $n = @data.shift;
my $s = @data.shift;
my @A = @data.shift.split: ' ';

my @B;

for @A -> $gc-content {
    push @B, ($n - $s.chars + 1) * prob :dna($s), :$gc-content;
}

say @B.fmt("%.3f");

# vim: expandtab shiftwidth=4 ft=perl6
