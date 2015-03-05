use v6;

=begin pod

=TITLE Finding a Motif in DNA

L<http://rosalind.info/problems/subs/>

Sample input

    GATATATGCATATACTT
    ATAT

Sample output

    2 4 10

=end pod

my ($S, $t) = $*IN.lines;
say gather for $S.match(/$t/, :overlap) { take 1+.from }

# vim: expandtab shiftwidth=4 ft=perl6
