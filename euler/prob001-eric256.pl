use v6;

my $sum;
for (1..^1000) -> $n { $sum+=$n unless $n % 5 and $n % 3};
$sum.say;
