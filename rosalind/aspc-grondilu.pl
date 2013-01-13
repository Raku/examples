use v6;

my ($n, $m) = get.words;
my $sum = my $C =  ([*] $n-$m+1 .. $n) div [*] 1 .. $m;
for $m+1 .. $n -> $k { $sum += $C = $C * ($n - $k + 1) div $k }
say $sum % 1_000_000;

# vim: ft=perl6
