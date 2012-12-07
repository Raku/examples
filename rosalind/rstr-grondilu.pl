use v6;

my @data = $*IN.lines;
my ($N, $gc-content) = @data.shift.split: " ";
my $dna = @data.shift;

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars * [*] map { $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content) }, $dna.comb
}

printf "%.3f",  1 - exp ($N * log(1-prob :$dna, :$gc-content));

# vim: ft=perl6

