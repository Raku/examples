# Solution to Project Euler’s http://projecteuler.net/problem=28
# by Shlomi Fish

use v6;

=begin pod

=head1 DESCRIPTION

Starting with the number 1 and moving to the right in a clockwise direction a 5
by 5 spiral is formed as follows:

21 22 23 24 25
20  7  8  9 10
19  6  1  2 11
18  5  4  3 12
17 16 15 14 13

It can be verified that the sum of the numbers on the diagonals is 101.

What is the sum of the numbers on the diagonals in a 1001 by 1001 spiral formed
in the same way?

=end pod

use v6;

my Int $sum = 0;

my Int $num = 1;

$sum += $num;

for 2, 4 ... 1000 -> $step
{
    for 0 .. 3
    {
        $num += $step;
        $sum += $num;
    }
}
print "Sum = $sum\n";

# vim: expandtab shiftwidth=4 ft=perl6
