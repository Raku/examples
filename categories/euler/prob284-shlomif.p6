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
