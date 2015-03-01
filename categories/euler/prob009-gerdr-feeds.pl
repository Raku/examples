use v6;

constant $N = 1000;

my $result;
1..Int((1 - sqrt(0.5)) * $N) \

# compute numerator and denominator of closed expression for b
==> map -> $a { [ $a, $N * ($N - 2 * $a), 2 * ($N - $a) ] } \

# check if closed expression yields an integer
==> grep -> [ $a, $u, $v ] { $u %% $v } \

# compute b and c
==> map -> [ $a, $u, $v ] { my $b = $u div $v; [ $a, $b, $N - $a - $b ] } \

# compute product
==> map -> @triple { [*] @triple } \

# ... to give the result.
# We don't .say directly on the output yet, since Rakudo (2015.02) doesn't
# yet handle this case of a feed into a .say
==> $result;

# print result
$result.say;

# vim: expandtab shiftwidth=4 ft=perl6
