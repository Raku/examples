use v6;

=begin pod

=TITLE Special Pythagorean triplet

=AUTHOR Gerhard R

L<https://projecteuler.net/problem=9>

A Pythagorean triplet is a set of three natural numbers, a < b < c, for
which,

    a^2 + b^2 = c^2

For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.


Solution method:

Let (a, b, c) be a pythagorean triple

a < b < c
a² + b² = c²

For N = a + b + c it follows

b = N·(N - 2a) / 2·(N - a)
c = N·(N - 2a) / 2·(N - a) + a²/(N - a)

which automatically meets b < c.

The condition a < b gives the constraint

a < (1 - 1/√2)·N

=end pod

sub triples($N) {
    for 1..Int((1 - sqrt(0.5)) * $N) -> $a {
        my $u = $N * ($N - 2 * $a);
        my $v = 2 * ($N - $a);

        # check if b = u/v is an integer
        # if so, we've found a triple
        if $u %% $v {
            my $b = $u div $v;
            my $c = $N - $a - $b;
            take $($a, $b, $c);
        }
    }
}

say [*] .list for gather triples(1000);

# vim: expandtab shiftwidth=4 ft=perl6
