my @FACTS = (1);
for 1 .. 100 -> $n
{
    @FACTS.push(@FACTS[*-1] * $n);
}

say @FACTS[10];



sub calc_count($l, $w_zero, $num_nat_digits)
{
    my $num_digits = $num_nat_digits + ($w_zero ?? 1 !! 0);
    if $num_digits > $l
    {
        return 0;
    }
    if ! $w_zero
    {
        sub rec(@counts, $s)
        {
            if $s > $l
            {
                return 0;
            }
            if @counts == $num_digits
            {
                if $s != $l
                {
                    return 0;
                }
                my $ret = @FACTS[$l] * @FACTS[$num_digits];
                my %repeats;
                for @counts -> $x
                {
                    $ret /= @FACTS[$x];
                    ++%repeats{$x};
                }
                for %repeats.values() -> $v
                {
                    $ret /= @FACTS[$v];
                }
                # say('ret = ', $ret, ' ',$s, ' ', $l, ' ', $num_digits, @counts);
                return $ret;
            }
            my $ret = 0;
            for 1 .. (+@counts ?? @counts[*-1] !! $l - $num_digits + 1) -> $nxt
            {
                $ret += rec([|@counts, $nxt], $s + $nxt);
            }
            return $ret;
        }
        return rec([], 0);
    }
    else
    {
        my $ret = 0;
        # Choose a pivot for the first place and go for it
        for 0 .. $l-2 -> $cnt
        {
            $ret += @FACTS[$l-1]/@FACTS[$cnt]/@FACTS[$l-1-$cnt] *
                   calc_count($l - 1 - $cnt, False, $num_nat_digits);
        }
        return $ret * $num_nat_digits;
        # raise BaseException("unimplemented")
    }
}

sub solve($myl)
{
    my @counts;
    for [False, True] -> $z
    {
        for 0 .. 9 -> $n
        {
            my $v = sum(map sub ($l) { calc_count($l, $z, $n) }, 0 .. $myl);
            if $v > 0
            {
                @counts.push([$z, $n, $v]);
            }
        }
    }
    say(@counts);
    my $ret = 0;
    for 0 ..^@counts -> $ik
    {
        my ($zi, $ni, $vi) = |@counts[$ik];
        for $ik ..^@counts -> $jk
        {
            my ($zj, $nj, $vj) = |@counts[$jk];
            for 0 .. min($ni, $nj) -> $num_common
            {
                if ($num_common == 0 and (!$zi or !$zj))
                {
                    next;
                }
                my $i_num_diff = $ni - $num_common;
                my $j_num_diff = $nj - $num_common;

                my $digs = $num_common + $i_num_diff + $j_num_diff;
                if $digs > 9
                {
                    next;
                }
                my $r = ($vi * $vj) * @FACTS[9] /
                    @FACTS[$num_common] / @FACTS[$i_num_diff] /
                    @FACTS[$j_num_diff] / @FACTS[9 - $digs];
                if $ik == $jk
                {
                    if $num_common == $ni
                    {
                        $r -= $vi * @FACTS[9] / @FACTS[$ni] / @FACTS[9 - $ni];
                    }
                }
                else
                {
                    $r *= 2;
                }

                say ("num_common=", $num_common, "i=", $ik, "j=", $jk,
                       "r=", $r);
                $ret += $r;
            }
        }
    }
    return $ret +> 1;
}

say ("s[fast] = ", solve(2));
my $my_solution = solve(18);
printf("solution = %d ( MOD = %d )\n", $my_solution, $my_solution % 1000267129);

=finish
