use v6;

=begin pod

=TITLE Perfect Matchings and RNA Secondary Structures

=AUTHOR L. Grondin

L<http://rosalind.info/problems/pmch/>

Sample input

    >Rosalind_23
    AGCUAGUCAU

Sample output

    12

=end pod

my $default-input = q:to/END/;
    >Rosalind_23
    AGCUAGUCAU
    END

sub MAIN($input-file = Nil) {
    my $input = $input-file ?? $input-file.IO.slurp !! $default-input;
    my $rna = join '', grep /^ <[ACGU]>+ $/, $input.lines;

    say [*] map { [*] 1 .. $rna.comb(/$_/).elems }, <U C>;
}

# vim: expandtab shiftwidth=4 ft=perl6
