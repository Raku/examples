use v6;

# Solve Project Euler’s Problem No. 188:
# http://projecteuler.net/problem=188
# “The Hyperexponentiation of a number.”

sub hyperexp_modulo(int $base, int $exp, int $mod) returns int
{
    if $exp == 1
    {
        return ($base % $mod);
    }

    my Int $mod1 = $base;
    my Int $e = 1;

    while $mod1 != 1
    {
        ($mod1 *= $base) %= $mod;
        $e++;
    }

    my int $mod_recurse = hyperexp_modulo($base, $exp - 1, $e);

    return $base.expmod($mod_recurse, $mod);
}

# print hyperexp_modulo(3, 3, 1000), "\n";

printf "Result == %08d\n", hyperexp_modulo(1777, 1855, 100_000_000);

# vim: expandtab shiftwidth=4 ft=perl6
