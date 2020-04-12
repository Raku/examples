#!/usr/bin/env perl6
=begin pod

=TITLE Steady Squares

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=284>

The 3-digit number 376 in the decimal numbering system is an example of numbers with the special property that
its square ends with the same digits: 3762 = 141376. Let's call a number with this property a steady square.

Steady squares can also be observed in other numbering systems. In the base 14 numbering system,
the 3-digit number c37 is also a steady square: c372 = aa0c37, and the sum of its digits is c+3+7=18
in the same numbering system. The letters a, b, c and d are used for the 10, 11, 12 and 13 digits respectively,
in a manner similar to the hexadecimal numbering system.

For 1 ≤ n ≤ 9, the sum of the digits of all the n-digit steady squares in the base 14 numbering system
is 2d8 (582 decimal). Steady squares with leading 0's are not allowed.

Find the sum of the digits of all the n-digit steady squares in the base 14 numbering system for 1 ≤ n ≤ 10000 (decimal)
and give your answer in the base 14 system using lower case letters where necessary.


=end pod

my $BASE = 14;
my $MAX = 10000;
# $MAX = 9;

my @MP;

my $ret = 0;

sub rec($n, $sq, $is_z, $digits_sum)
{
    if ($n > $MAX)
    {
        return;
    }
    if ((($sq*$sq) % @MP[$n][1]) != $sq)
    {
        return;
    }
    if ($sq == 0 and $n > 3)
    {
        return;
    }
    if (! $is_z)
    {
        $ret += $digits_sum;
    }
    my $M = @MP[$n];
    for 0 .. $BASE - 1 -> $d
    {
        rec($n+1, $sq+$M[$d], ($d == 0), $digits_sum+$d);
    }
}

@MP[0] = [ 0 .. $BASE - 1];
for 1 .. $MAX + 1 -> $n
{
    @MP.push([map { @MP[*-1][1] * $_ * $BASE }, 0 .. $BASE - 1]);
}
rec(0, 0, True, 0);

sub base14($n)
{
    if $n == 0
    {
        return '';
    }
    else
    {
        return base14($n div $BASE) ~ sprintf("%x", $n % $BASE);
    }
}
say base14($ret);
