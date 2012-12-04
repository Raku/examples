use v6;

# This program doesn't really simulate anything and is only here for the sake of
# completeness. But to show something cool about perl6 let's at least introduce
# the faculty as the ! postfix operator
my Int sub postfix:<!>(Int $n) { [*] 1 .. $n }

# The strategy for this Problem is quite straight-forward: To move from the
# upper left to the lower right corner of an NxN grid without ever going in the
# wrong direction one has to go down N times and one has to go right N times.
# The problem is therefore equivalent to "How many distinguishable ways exist to
# order N white and N black balls?" and the answer to that problem is:

my \N = 20;
say (2 * N)!/(N! * N!);
