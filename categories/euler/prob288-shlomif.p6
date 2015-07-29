use v6;

sub factorial_factor_exp($n , $f)
{
    if ($n < $f)
    {
        return 0;
    }
    else
    {
        my $div = $n / $f;
        return $div + factorial_factor_exp($div, $f);
    }
}

my @t_n;

my $N_LIM = 10;
my $BASE = 61;
my $LIM = 10_000_000;

my $S_0 = 290797;
my $s = $S_0;

for (0 .. $N_LIM-1) -> $n {
    @t_n.push($s % $BASE);
    $s = (($s * $s) % 50515093);
}

my $sum = 0;
for ($N_LIM .. $LIM) -> $n {
    if $n % 10_000 == 0 {
        say "Reached $n";
    }
    $sum += ($s % $BASE);
    $s = (($s * $s) % 50515093);
}

sub f($n)
{
    return factorial_factor_exp($n, ($BASE)) % (($BASE) ** $N_LIM);
}

say "Solution == ", +([+] (
    (map { f(($BASE) ** $_) * @t_n[$_] }, 1 .. @t_n-1),
    $sum * f(($BASE) ** $N_LIM)
)) % (($BASE) ** $N_LIM);
