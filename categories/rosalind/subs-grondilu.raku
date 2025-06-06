use v6;

=begin pod

=TITLE Finding a Motif in DNA

=AUTHOR L. Grondin

L<http://rosalind.info/problems/subs/>

Sample input

    GATATATGCATATACTT
    ATAT

Sample output

    2 4 10

=end pod

my @default-data = qw{GATATATGCATATACTT ATAT};

sub MAIN($input-file = Nil) {
    my ($S, $t) = $input-file ?? $input-file.IO.lines !! @default-data;
    my @arr = gather for $S.match(/$t/, :overlap) { take 1+.from };
    say "{@arr}"
}

# vim: expandtab shiftwidth=4 ft=perl6
