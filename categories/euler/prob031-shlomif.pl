use v6;

=begin pod

=TITLE Coin sums

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=31>

In England the currency is made up of pound, £, and pence, p, and there are
eight coins in general circulation:

    1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).

It is possible to make £2 in the following way:

    1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p

How many different ways can £2 be made using any number of coins?

=end pod

my @coins = (1,2,5,10,20,50,100,200);

my @r_coins = @coins.reverse;

my %cache;

sub calc(Int $max_idx, Int $sum) {
    return %cache{"$max_idx,$sum"} //= do {
        my Int $ret;
        if ($max_idx == @r_coins.end) {
            $ret = 1;
        }
        elsif ($sum < @r_coins[$max_idx]) {
            $ret = calc($max_idx+1, $sum);
        }
        else {
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
