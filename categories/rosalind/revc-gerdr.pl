use v6;

=begin pod

=TITLE Complementing a Strand of DNA

=AUTHOR grondilu

L<http://rosalind.info/problems/revc/>

Sample input

    AAAACCCGGT

Sample output

    ACCGGGTTTT

=end pod

sub MAIN($input = "AAAACCCGGT") {
    .flip.trans('ACGT' => 'TGCA').say given $input;
}

# vim: expandtab shiftwidth=4 ft=perl6
