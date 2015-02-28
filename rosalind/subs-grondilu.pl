use v6;

my ($S, $t) = $*IN.lines;
say gather for $S.match(/$t/, :overlap) { take 1+.from }

# vim: expandtab shiftwidth=4 ft=perl6
