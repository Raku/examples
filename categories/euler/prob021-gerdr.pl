use v6;

=begin pod

=TITLE Amicable numbers

=AUTHOR Gerhard R

L<https://projecteuler.net/problem=21>

Let d(n) be defined as the sum of proper divisors of n (numbers less than n
which divide evenly into n).  If d(a) = b and d(b) = a, where a ≠ b, then a
and b are an amicable pair and each of a and b are called amicable numbers.

For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44,
55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4,
71 and 142; so d(284) = 220.

Evaluate the sum of all the amicable numbers under 10000.

=end pod

sub d(Int $n) {
    my $sum = 1;
    my $sqrt-n = sqrt $n;

    for 2..Int($sqrt-n) -> $a {
        my $b = $n div $a;
        $sum += $a + $b if $a * $b == $n;
    }

    $sqrt-n ~~ Int ?? $sum - $sqrt-n !! $sum;
}

my $sum = 0;

for 1..100_000 -> $a {
    my $b = d($a);
    $sum += $a + $b if $a < $b and d($b) == $a;
}

say $sum;

# vim: expandtab shiftwidth=4 ft=perl6
