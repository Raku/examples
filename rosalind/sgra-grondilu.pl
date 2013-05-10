use v6;
use List::Utils;

my %mass-table = slurp('monoisotopic-mass-table.txt').words;
my @L = sort lines;
# <1 132.04049>;
# <3524.8542 3623.5245 3710.9335 3841.974 3929.00603 3970.0326 4026.05879 4057.0646 4083.08025>;
my %invert-mass-table = %mass-table.invert.hash;
# for %mass-table.invert { %invert-mass-table{.key}.push: .value }
my @masses = sort +*, %mass-table.values;
my %precision = @L Z=> map { $^x / $x.subst(/\./, '') }, @L;

sub spectrum-graph(@L) {
    my %edges;
    for ^@L -> $i {
	my $u = @L[$i];
        for @L[$i+1..*-1] -> $v {
            note my $precision = max %precision{$u, $v};
	    my $diff = $v - $u;
	    my $bound = upper-bound(@masses, $diff);
	    my $mass = $bound == 0 ?? @masses[0] !!
	    $bound == @masses.elems ?? @masses[*-1] !!
	    min :by({abs($diff-$_)}), @masses[$bound-1, $bound];
	    if abs($diff - $mass) < $precision {
		#note "$i $precision $diff $mass";
		%edges{$u}.push: {
		    next-mass => $v,
		    amino-acid => %invert-mass-table{$mass}
		};
	    }
        }
    }
    return %edges;
}

my %graph = spectrum-graph(@L);
sub find-protein($initial-mass) {
    return '' unless %graph{$initial-mass} :exists;
    gather for %graph{$initial-mass}[] -> $node {
	take $node<amino-acid> «~« find-protein($node<next-mass>);
    }
}

my @protein = map &find-protein, @L;
say max :by(*.chars), @protein;

# vim: ft=perl6
