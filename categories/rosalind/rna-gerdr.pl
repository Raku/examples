use v6;

=begin pod

=TITLE Transcribing DNA into RNA

=AUTHOR gerdr

L<http://rosalind.info/problems/rna/>

Sample input

    GATGGAACTTGACTACGTAAATT

Sample output

    GAUGGAACUUGACUACGUAAAUU

=end pod

sub MAIN(Str $input = "GATGGAACTTGACTACGTAAATT") {
    .trans('T' => 'U').say given $input;
}

# vim: expandtab shiftwidth=4 ft=perl6
