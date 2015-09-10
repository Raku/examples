use v6;

=begin pod

=TITLE Introduction to Random Strings

=AUTHOR L. Grondin

L<http://rosalind.info/problems/prob/>

Sample input

    ACGATACAA
    0.129 0.287 0.423 0.476 0.641 0.742 0.783

Sample output

    -5.737 -5.217 -5.263 -5.360 -5.958 -6.628 -7.009

=end pod

my @sample = "ACGATACAA
0.129 0.287 0.423 0.476 0.641 0.742 0.783".split: "\n";

sub MAIN($input-file = Nil) {
    my ($dna, $gc-content-string) = $input-file ?? $input-file.IO.lines !! @sample;
    my @A = $gc-content-string.split(" ");
    my @B = map { log(prob :$dna, :gc-content($_))/log(10) }, @A;

    say "{@B».fmt: "%.3f"}";
}

sub prob(:$dna, :$gc-content) {
    1/2**$dna.chars * [*] map {
        $_ eq 'G'|'C' ?? $gc-content !! (1 - $gc-content)
    }, $dna.comb;
}

# vim: expandtab shiftwidth=4 ft=perl6
