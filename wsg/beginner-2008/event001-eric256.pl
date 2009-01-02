use v6;

my @cards = <6 5 6 6 "K">; 
my $p = 0; 
for @cards[0..@cards-2].kv -> $k, $v { 
   $p += (@cards[$k+0..^@cards].grep: {$_ == $v}).elems -1 
}; 
say $p;

