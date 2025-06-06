use v6;

=begin pod

=TITLE Permuted multiples

=AUTHOR Jonathan Scott Duff

L<https://projecteuler.net/problem=52>

It can be seen that the number, 125874, and its double, 251748, contain
exactly the same digits, but in a different order.

Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x,
contain the same digits.

=end pod

my $mag = 1;        # current power of 10
my $n = $mag;       # number to start searching from
loop {
    my $s = (2*$n).comb.sort;
    last if
    $s eq (3*$n).comb.sort &&
    $s eq (4*$n).comb.sort &&
    $s eq (5*$n).comb.sort &&
    $s eq (6*$n).comb.sort;
    $n++;
    if log10(6*$n).Int > log10(2*$n).Int {
        $mag *= 10;
        $n = $mag;
    }
}
say $n;

# vim: expandtab shiftwidth=4 ft=perl6
