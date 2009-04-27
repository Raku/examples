use v6;

our $SHIPS = 4;
our $REPS  = 30;

my @weights = list(1..$SHIPS).map: { 1+16.rand.int };
for @weights.kv -> $k, $v { say "$k: $v" }

my $total = [+] @weights;
say "Total Weights $total";

sub pick (@weights, $total) {
   my $rand = $total.rand.int;
   for @weights.kv -> $i, $w {
       $rand -= $w;
       return $i if $rand < 0;
   }
}

sub pickAll (@w,$t) {
   my @weights = @w.clone; my $total = $t.clone;  #a hack until "is copy" gets implemented
   my @order;
   for @weights {
        my $pick = pick(@weights, $total);
        @order.push($pick);
        $total -= @weights[$pick];
        @weights[$pick] = 0;
   }
   return @order;
 }

pickAll(@weights,$total).join.say for 1 .. $REPS;



