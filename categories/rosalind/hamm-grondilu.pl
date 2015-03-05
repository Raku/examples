use v6;


sub MAIN(@default-data = qw{GAGCCTACTAACGGGAT CATCGTAATGACGGCCT}) {
    my ($S, $t) = @default-data;
    say [+] ($S.comb Zeq $t.comb)».not».Int;
}

# vim: expandtab shiftwidth=4 ft=perl6
