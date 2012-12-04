use v6;

my ($S, $t) = $*IN.lines;
say [+] ($S.comb Zeq $t.comb)».not».Int;

# vim: ft=perl6
