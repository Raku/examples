use v6;

=begin pod

=TITLE The hyperexponentiation of a number

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=188>

The hyperexponentiation or tetration of a number a by a positive integer b,
denoted by a↑↑b or ᵇa, is recursively defined by:

a↑↑1 = a,
a↑↑(k+1) = a(a↑↑k).

Thus we have e.g. 3↑↑2 = 3³ = 27, hence 3↑↑3 = 3²⁷ = 7625597484987 and 3↑↑4 is
roughly 103.6383346400240996*10^12.

Find the last 8 digits of 1777↑↑1855.

=end pod

sub hyperexp_modulo(int $base, int $exp, int $mod) returns int {
    if $exp == 1 {
        return ($base % $mod);
    }

    my Int $mod1 = $base;
    my Int $e = 1;

    while $mod1 != 1 {
        ($mod1 *= $base) %= $mod;
        $e++;
    }

    my int $mod_recurse = hyperexp_modulo($base, $exp - 1, $e);

    return $base.expmod($mod_recurse, $mod);
}

printf "%08d\n", hyperexp_modulo(1777, 1855, 100_000_000);

# vim: expandtab shiftwidth=4 ft=perl6
