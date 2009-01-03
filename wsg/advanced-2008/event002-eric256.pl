use v6;

my @lines = slurp("skaters.txt").split("\n");

my %skaters ;
for @lines {
    next unless .chars > 0;
	my @data = .split(',');
	my $score = [+] (@data[1..7].sort)[2..6];
	%skaters{@data[0]} = $score / 5
}

my ($gold, $silver, $bronze) = %skaters.pairs.sort({$^b.value <=> $^a.value})[0,1,2];
say "Gold: {$gold.key}: {$gold.value}";
say "Silver: {$silver.key}: {$silver.value}";
say "Bronze: {$bronze.key}: {$bronze.value}";

