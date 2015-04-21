use v6;

=begin pod

=TITLE Weighted roll

=AUTHOR Eric Hodges

Specification:

From L<http://www.perlmonks.org/?node_id=731443>

This is part of a strategy game. There are a number of ships in combat,
and you must determine which order they get to take their actions.

=item Each ship has an initiative value.
=item At the start of the turn, each ship gets a number of ballots equal to
      their initiative. The ballots are drawn out randomly. The first time a
      ship's ballot gets drawn, it takes its turn. The rest of its ballots
      are wasted.

Worked example:

=item 3 ships <A B C> with initiative (1,2,4).
=item We put ballots into an array: <A B B C C C C>
=item We draw a ballot out at random: C. C takes its turn.
=item We draw another ballot:  C. do nothing.
=item We draw another ballot:  C. do nothing.
=item We draw another ballot:  B. B takes its turn.
=item We draw another ballot:  B. do nothing.
=item We draw another ballot:  A. A takes its turn.
=item We draw the last ballot: C. do nothing.
=item So the final order is: <C B A>

This is not necessarily the most efficient way to perform the algorithm.

Useful things to note:

=item to generate a random number from 1 to N, use C<(1..N).pick>
=item to generate a random number from 0 to N-1, use C<(0..^N).pick>

=end pod

our $SHIPS = 4;
our $REPS  = 30;

my @weights = (1..16).pick($SHIPS, :replace);
for @weights.kv -> $k, $v { say "$k: $v" }

my $total = [+] @weights;
say "Total Weights $total";

sub pick(@weights, $total) {
   my $rand = (0..^$total).pick;
   for @weights.kv -> $i, $w {
       $rand -= $w;
       return $i if $rand < 0;
   }
}

sub pickAll(@weights is copy, $total is copy) {
   my @order;
   for @weights {
        my $pick = pick(@weights, $total);
        @order.push($pick);
        $total -= @weights[$pick];
        @weights[$pick] = 0;
   }
   return @order;
 }

say ~pickAll(@weights,$total) for 1 .. $REPS;

# vim: expandtab shiftwidth=4 ft=perl6
