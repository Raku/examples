use v6;

=begin pod

=TITLE Arranged probability

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=100>

If a box contains twenty-one coloured discs, composed of fifteen blue discs
and six red discs, and two discs were taken at random, it can be seen that
the probability of taking two blue discs, P(BB) = (15/21)×(14/20) = 1/2.

The next such arrangement, for which there is exactly 50% chance of taking
two blue discs at random, is a box containing eighty-five blue discs and
thirty-five red discs.

By finding the first arrangement to contain over 10¹² = 1,000,000,000,000
discs in total, determine the number of blue discs that the box would
contain.

=end pod

my $blue  = 15;
my $total = 21;

( $blue ,
  $total ) =  3 * $blue + 2 * $total - 2,
              4 * $blue + 3 * $total - 3
      while $total <= 10 ** 12 ;

say $blue;

# vim: expandtab shiftwidth=4 ft=perl6
