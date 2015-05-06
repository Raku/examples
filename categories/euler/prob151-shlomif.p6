use v6;

my $total_num = 0;
my $sum = 0;

# rec is short for "recurse".
sub rec($factor, @counts, $result)
{
    say @counts.join(",");
    my $cnt = [+] @counts;
    if $cnt == 0
    {
        $sum += $factor * $result;
        $total_num += $factor;
    }
    else
    {
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
                rec( $factor*$f/$cnt, @c, $result + ($cnt == 1) );
            }
        }
    }
    return;
}

rec(1,[1],0);

say "Result == ", ($sum / $total_num - 2).fmt("%.6f");
