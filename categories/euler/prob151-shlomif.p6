use v6;

my $sum = 0;

# rec is short for "recurse".
# $n is numerator ; $d is denominator
sub rec($n, $d, @counts, $result)
{
    say @counts.join(",");
    my $cnt = [+] @counts;
    if $cnt == 0
    {
        $sum += $n * $result / $d;
    }
    else
    {
        my $new_r = $result + ($cnt == 1);
        my $new_d = $d*$cnt;
        for (@counts.kv) -> $size, $f
        {
            if $f > 0
            {
                my @c = @counts;
                @c[$size]--;
                for $size ^.. 4 -> $s
                {
                    @c[$s]++;
                }
                rec( $n*$f, $new_d, @c, $new_r );
            }
        }
    }
    return;
}

rec(1, 1, [1],0);

say "Result == ", ($sum - 2).fmt("%.6f");
