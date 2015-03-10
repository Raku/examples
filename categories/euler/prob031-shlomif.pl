use v6;

my @coins = (1,2,5,10,20,50,100,200);

my @r_coins = @coins.reverse;

# say @r_coins.join(",")

my %cache;

sub calc(Int $max_idx, Int $sum)
{
    return %cache{"$max_idx,$sum"} //= do {
        my Int $ret;
        if ($max_idx == @r_coins.end)
        {
            $ret = 1;
        }
        elsif ($sum < @r_coins[$max_idx])
        {
            $ret = calc($max_idx+1, $sum);
        }
        else
        {
            $ret =
            (
                calc($max_idx+1, $sum)
                + calc($max_idx, $sum-@r_coins[$max_idx])
            );
        }
        $ret;
    };
}

print calc(0, 200), "\n";

# vim: expandtab shiftwidth=4 ft=perl6
