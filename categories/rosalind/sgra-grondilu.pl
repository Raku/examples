use v6;

=begin pod

=TITLE Using the Spectrum Graph to Infer Peptides

=AUTHOR L. Grondin

L<http://rosalind.info/problems/sgra/>

Sample input

    3524.8542
    3623.5245
    3710.9335
    3841.974
    3929.00603
    3970.0326
    4026.05879
    4057.0646
    4083.08025

Sample output

    WMSPG

=end pod

my $default-input = q:to/END/;
    3524.8542
    3623.5245
    3710.9335
    3841.974
    3929.00603
    3970.0326
    4026.05879
    4057.0646
    4083.08025
    END

sub MAIN($input-file = Nil) {
    my $input = $input-file ?? $input-file.IO.slurp !! $default-input;

    my $mass-table-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname,
                                        "monoisotopic-mass-table.txt");
    my %mass-table = slurp($mass-table-file).words;
    my @L = sort $input.lines;
    my %invert-mass-table = %mass-table.invert.hash;

    sub spectrum-graph(@L) {
        my %edges;
        for ^@L -> $i {
            note
            my $u = @L[$i];
            for @L[$i+1..*-1] -> $v {
                my $mass = %invert-mass-table{$v - $u};
                %edges{$u}.push: {
                    next-mass => $v,
                    amino-acid => $mass;
                } if defined $mass;
            }
        }
        return %edges;
    }

    my %graph = spectrum-graph(@L);
    sub find-protein($initial-mass) {
        return '' unless %graph{$initial-mass} :exists;
        gather for %graph{$initial-mass}[] {
            take .<amino-acid> «~« find-protein(.<next-mass>);
        }
    }

    say max :by(*.chars), map &find-protein, @L;
}

# vim: expandtab shiftwidth=4 ft=perl6
