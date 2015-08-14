use v6;

=begin pod

=TITLE Lattice paths

=AUTHOR Felix Herrmann

L<https://projecteuler.net/problem=15>

Starting in the top left corner of a 2×2 grid, and only being able to move
to the right and down, there are exactly 6 routes to the bottom right
corner.

How many such routes are there through a 20×20 grid?

=end pod

# This program doesn't really simulate anything and is only here for the
# sake of completeness. But to show something cool about perl6 let's at
# least introduce the factorial as the ! postfix operator
my Int sub postfix:<!>(Int $n) { [*] 1 .. $n }

# The strategy for this Problem is quite straight-forward: To move from the
# upper left to the lower right corner of an NxN grid without ever going in
# the wrong direction one has to go down N times and one has to go right N
# times.  The problem is therefore equivalent to "How many distinguishable
# ways exist to order N white and N black balls?" and the answer to that
# problem is:

my \N = 20;
say (2 * N)!/(N! * N!);

# vim: expandtab shiftwidth=4 ft=perl6
