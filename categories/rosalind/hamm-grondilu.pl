use v6;

my ($S, $t) = $*IN.lines;
say [+] ($S.comb Zeq $t.comb)».not».Int;

# vim: expandtab shiftwidth=4 ft=perl6
