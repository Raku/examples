my @FACTS = (1);
for 1 .. 100 -> $n
{
    @FACTS.push(@FACTS[*-1] * $n);
}

say @FACTS[10];

sub nCr($n, @k_s) {
    return @FACTS[$n] / [*] @FACTS[|@k_s, $n-@k_s.sum];
}


sub calc_count($l, $w_zero, $num_nat_digits)
{
    my $num_digits = $num_nat_digits + ($w_zero ?? 1 !! 0);
    if $num_digits > $l
    {
        return 0;
    }
    if $w_zero
    {
        my $ret = 0;
        # Choose a pivot for the first place and go for it
        for 0 .. $l-2 -> $cnt
        {
            $ret += nCr($l-1, [$cnt]) *
                calc_count($l - 1 - $cnt, False, $num_nat_digits);
        }
        return $ret * $num_nat_digits;
    }
    sub rec(@counts, $sum)
    {
        if $sum > $l
        {
            return 0;
        }
        if @counts == $num_digits
        {
            if $sum != $l
            {
                return 0;
            }
            return nCr($l, @counts) * nCr($num_digits,(bag @counts).values);
        }
        my $ret = 0;
        for 1 .. (+@counts ?? @counts[*-1] !! $l - $num_digits + 1) -> $nxt
        {
            $ret += rec([|@counts, $nxt], $sum + $nxt);
        }
        return $ret;
    }
    return rec([], 0);
}

sub solve($myl)
{
    my @counts;
    for [False, True] -> $z
    {
        for 0 .. 9 -> $n
        {
            my $v = sum(map { calc_count($_, $z, $n) }, 0 .. $myl);
            if $v > 0
            {
                @counts.push([$z, $n, $v]);
            }
        }
    }
    say(@counts);
    my $ret = 0;
    for 0 ..^@counts -> $i
    {
        my ($zi, $ni, $vi) = |@counts[$i];
        for $i ..^@counts -> $j
        {
            my ($zj, $nj, $vj) = |@counts[$j];
            for 0 .. min($ni, $nj) -> $num_common
            {
                if ($num_common == 0 and (!$zi or !$zj))
                {
                    next;
                }
                my $i_num_diff = $ni - $num_common;
                my $j_num_diff = $nj - $num_common;

                if $num_common + $i_num_diff + $j_num_diff > 9
                {
                    next;
                }
                my $result = $vi * $vj * nCr(9, [$num_common, $i_num_diff, $j_num_diff]);
                if $i == $j
                {
                    if $num_common == $ni
                    {
                        $result -= $vi * nCr(9, [$ni])
                    }
                }
                else
                {
                    $result *= 2;
                }

                say ("num_common=", $num_common, "i=", $i, "j=", $j,
                       "r=", $result);
                $ret += $result;
            }
        }
    }
    return $ret +> 1;
}

say ("s[fast] = ", solve(2));
my $my_solution = solve(18);
printf("solution = %d ( MOD = %d )\n", $my_solution, $my_solution % 1000267129);

=finish
