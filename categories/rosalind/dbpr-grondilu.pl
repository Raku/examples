use v6;

=begin pod

=TITLE Introduction to Protein Databases

=AUTHOR L. Grondin

L<http://rosalind.info/problems/dbpr/>

Sample input

    Q5SLP9

Sample output

    DNA recombination
    DNA repair
    DNA replication

=end pod

use LWP::Simple;

sub MAIN(Str $id = "Q5SLP9") {
    my $id-fname = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "$id.txt");
    my $input = $id-fname.IO.e
        ?? $id-fname.IO.slurp
        !! LWP::Simple.get(qq{http://www.uniprot.org/uniprot/$id.txt});
    for split "\n", $input {
        if / GO\; .* \sP\: (.*?)\;/ {
            say $/[0].Str
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
