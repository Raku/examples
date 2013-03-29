use v6;

my $rna = lines[1..*-1].join;
my $bag = $rna.comb.bag;

sub C($k, $n) {
   if $k < 0 or $k > $n { return 0 }
   elsif $k < 2 { return $n }
   elsif $k == $n { return 1 }
   else {
       return (state @)[$n][$k] //= C($k-1, $n-1) + C($k, $n-1)
   }
}

sub postfix:<!>(Int $n) { [*] 1 .. $n }

say
C($bag<A U>.min, $bag<A U>.max) * $bag<A U>.min!  *
C($bag<C G>.min, $bag<C G>.max) * $bag<C G>.min!;
