use v6;

=begin pod

=TITLE Perfect Matchings and RNA Secondary Structures

=AUTHOR grondilu

L<http://rosalind.info/problems/pmch/>

Sample input

    >Rosalind_23
    AGCUAGUCAU

Sample output

    12

=end pod

my $rna = join '', grep /^ <[ACGU]>+ $/, lines;

say [*] map { [*] 1 .. $rna.comb(/$_/).elems }, <U C>;

# vim: expandtab shiftwidth=4 ft=perl6
