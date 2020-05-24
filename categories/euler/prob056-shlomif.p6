# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

my $max = 0;
for 2 .. 99 -> $base
{
    my $power-result = $base;
    for 1 .. 99
    {
        my $digits-sum = [+] "$power-result".comb();
        if $digits-sum > $max
        {
            $max = $digits-sum;
        }
        $power-result *= $base;
    }
}
say $max;
