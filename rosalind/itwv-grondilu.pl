# Solution for http://rosalind.info/problems/itwv/
#
# THIS IS WAY TOO SLOW!!
#
use v6;
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
    say gather for @motif -> $b {
	my @interwove = interwove($a, $b).uniq;
	take %seen{sort($a, $b).join(':')} //=
	+so grep rx/ <@interwove> /, $dna;
    }
}

# vim: ft=perl6
