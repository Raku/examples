use v6;

=begin pod

=TITLE Hailstone sequence

=AUTHOR TimToady

The Hailstone sequence of numbers can be generated from a starting positive
integer, n by:

* If n is 1 then the sequence ends.
* If n is even then the next n of the sequence = n/2
* If n is odd then the next n of the sequence = (3 * n) + 1

The (unproven), Collatz conjecture is that the hailstone sequence for any
starting number always terminates.

=head1 Task

Create a routine to generate the hailstone sequence for a number.

Use the routine to show that the hailstone sequence for the number 27 has 112
elements starting with 27, 82, 41, 124 and ending with 8, 4, 2, 1

Show the number less than 100,000 which has the longest hailstone sequence
together with that sequence's length.

(But don't show the actual sequence)!

=head1 More

U<http://rosettacode.org/wiki/Hailstone_sequence#Raku>


=end pod

sub hailstone($n) { $n, { $_ %% 2 ?? $_ div 2 !! $_ * 3 + 1 } ... 1 }

my @h = hailstone(27);
say "Length of hailstone(27) = {+@h}";
say ~@h;

my $m max= +hailstone($_) => $_ for 1..99_999;
say "Max length $m.key() was found for hailstone($m.value()) for numbers < 100_000";


# vim: expandtab shiftwidth=4 ft=perl6
