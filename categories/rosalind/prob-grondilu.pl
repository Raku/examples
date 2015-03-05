use v6;

=begin pod

=TITLE Introduction to Random Strings

L<http://rosalind.info/problems/prob/>

Sample input

    ACGATACAA
    0.129 0.287 0.423 0.476 0.641 0.742 0.783

Sample output

    -5.737 -5.217 -5.263 -5.360 -5.958 -6.628 -7.009

=end pod

my @sample = "ACGATACAA
0.129 0.287 0.423 0.476 0.641 0.742 0.783".split: "\n";

my $dna = $*IN.get;
my @A = $*IN.get.split(" ");

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars * [*] map { $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content) }, $dna.comb
}

my @B = map { log(prob :$dna, :gc-content($_))/log(10) }, @A;

say @B».fmt: "%.3f";

# vim: expandtab shiftwidth=4 ft=perl6
