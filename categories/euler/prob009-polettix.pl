use v6;

=begin pod

=TITLE Special Pythagorean triplet

=AUTHOR Flavio Poletti

L<https://projecteuler.net/problem=9>

A Pythagorean triplet is a set of three natural numbers, a < b < c, for
which,

    a^2 + b^2 = c^2

For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.

Solution method:

$x + $y + $z = 1000 means that we can solve for $z:

$z = 1000 - $x - $y

We can safely assume that $x < $y < $z because the three numbers will be
different and can be ordered. Hence, it suffices to iterate $x from 1 up
to 1000/3, iterate $y from $x + 1 up to the midway to 1000 and get $z
accordingly. This speeds up things in Rakudo!

=end pod

my $sum = 1000;
for 1 .. ($sum / 3) -> $x {
    for ($x + 1) .. (($sum + $x) / 2) -> $y {
        my $z = $sum - $x - $y;
        if ($z * $z == $x * $x + $y * $y) {
            say $x * $y * $z;
            exit;
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
