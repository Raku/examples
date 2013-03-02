my $rna = join '', grep /^ <[ACGU]>+ $/, lines;

say [*] map { [*] 1 .. $rna.comb(/$_/).elems }, <U C>;

# vim: ft=perl6
