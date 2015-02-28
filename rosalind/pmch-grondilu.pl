use v6;

my $rna = join '', grep /^ <[ACGU]>+ $/, lines;

say [*] map { [*] 1 .. $rna.comb(/$_/).elems }, <U C>;

# vim: expandtab shiftwidth=4 ft=perl6
