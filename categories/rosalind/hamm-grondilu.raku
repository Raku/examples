use v6;

=begin pod

=TITLE Counting Point Mutations

=AUTHOR L. Grondin

Evolution as a Sequence of Mistakes

L<http://rosalind.info/problems/hamm/>

Sample input

    GAGCCTACTAACGGGAT
    CATCGTAATGACGGCCT

Sample output

    7

=end pod

sub MAIN(@default-data = qw{GAGCCTACTAACGGGAT CATCGTAATGACGGCCT}) {
    my ($S, $t) = @default-data;
    say [+] ($S.comb Zeq $t.comb)».not».Int;
}

# vim: expandtab shiftwidth=4 ft=perl6
