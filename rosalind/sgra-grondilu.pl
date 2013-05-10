use v6;
use List::Utils;

my %mass-table = slurp('monoisotopic-mass-table.txt').words;
my @L = sort lines;
my %invert-mass-table = %mass-table.invert.hash;

sub spectrum-graph(@L) {
    my %edges;
    for ^@L -> $i {
        note
        my $u = @L[$i];
        for @L[$i+1..*-1] -> $v {
            my $mass = %invert-mass-table{$v - $u};
            %edges{$u}.push: {
                next-mass => $v,
                amino-acid => $mass;
            } if defined $mass;
        }
    }
    return %edges;
}

my %graph = spectrum-graph(@L);
sub find-protein($initial-mass) {
    return '' unless %graph{$initial-mass} :exists;
    gather for %graph{$initial-mass}[] {
        take .<amino-acid> «~« find-protein(.<next-mass>);
    }
}

say max :by(*.chars), map &find-protein, @L;

# vim: ft=perl6
