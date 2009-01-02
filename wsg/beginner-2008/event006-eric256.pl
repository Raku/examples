use v6;

my $lines = slurp("coffee.txt").chomp;
my %order;
for $lines.split(/\n/) {
   my ($drink, $amount) = $_.split(' ');
   next if $drink eq 'Office';
   %order{$drink} += $amount;
}

for %order.kv -> $drink, $qty {
	"{$drink} {$qty}".say;
}
