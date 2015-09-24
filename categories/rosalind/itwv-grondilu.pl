use v6;

=begin pod

=TITLE Finding Disjoint Motifs in a Gene

=AUTHOR grondilu

L<http://rosalind.info/problems/itwv/>

Sample input

    GACCACGGTT
    ACAG
    GT
    CCG

Sample output

    0 0 1
    0 1 0
    1 0 0

=end pod

# THIS IS WAY TOO SLOW!!
#
my $dna = 'GACCACGGTT';
my @motif = <ACAG GT CCG>;

sub interwove($a, $b) {
    gather if none($a, $b) eq '' {
        for &?ROUTINE($a.substr(1), $b) {
            take $a.substr(0,1) ~ $_
        }
        for &?ROUTINE($a, $b.substr(1)) {
            take $b.substr(0,1) ~ $_
        }
    }
    elsif $a eq '' { take $b }
    else { take $a }
}

my %seen;
for @motif -> $a {
    my @arr = gather for @motif -> $b {
        my @interwove = interwove($a, $b).unique;
        take %seen{sort($a, $b).join(':')} //=
        +so grep rx/ <@interwove> /, $dna;
    }
    say "{@arr}"
}

# vim: expandtab shiftwidth=4 ft=perl6
