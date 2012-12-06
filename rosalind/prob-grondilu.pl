use v6;

my @sample = "ACGATACAA
0.129 0.287 0.423 0.476 0.641 0.742 0.783".split: "\n";

my $dna = $*IN.get;
my @A = $*IN.get.split(" ");

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars * [*] map { $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content) }, $dna.comb
}

my @B = map { log(prob :$dna, :gc-content($_))/log(10) }, @A;

say @B».fmt: "%.3f";

# vim: ft=perl6

