use v6;

=begin pod

=TITLE Diophantine equation

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=66>

Consider quadratic Diophantine equations of the form: x² – D×y² = 1

For example, when D=13, the minimal solution in x is 649² – 13×180² = 1.

It can be assumed that there are no solutions in positive integers when D is
square.

By finding minimal solutions in x for D = {2, 3, 5, 6, 7}, we obtain the
following:

3² – 2×2²= 1

2² – 3×1²= 1

9² – 5×4²= 1

5² – 6×2²= 1

8² – 7×3²= 1

Hence, by considering minimal solutions in x for D ≤ 7, the largest x is
obtained when D=5.

Find the value of D ≤ 1000 in minimal solutions of x for which the largest
value of x is obtained.

The following algorithm was used for the solution:
L<https://en.wikipedia.org/wiki/Chakravala_method>

=end pod

subset NonSquarable where *.sqrt !%% 1;

sub next-triplet([\a,\b,\k], \N) {

    # finding minimal l
    1 .. N.sqrt.floor
        ==> grep  -> \l { (a + b * l) %% k } \
        ==> sort  -> \l { abs(l ** 2 - N)  } \
        ==> my @r;

    my \l = @r.shift;

      (a * l + N * b) / abs(k)
    , (a + b * l)     / abs(k)
    , (l ** 2 - N )   / k
}

sub simple-solution(NonSquarable \N) {

    my $a = N.sqrt.floor;
    my $b = 1;
    my $k = $a ** 2 - N;

    $a, $b, $k;
}

sub chakravala(NonSquarable \N) {
    # Start with a solution for a² - N b² = k

    my ($a, $b, $k) = simple-solution N;

    ($a,$b,$k) = next-triplet [$a,$b,$k], N
        while $k != 1;

    $a, $b, $k;
}


1 .. 1000
    ==> grep NonSquarable                \
    ==> map -> \D { [D, chakravala D] }  \
    ==> sort *[2] ==> my @x;

say @x.pop[0];

# vim: expandtab shiftwidth=4 ft=perl6
