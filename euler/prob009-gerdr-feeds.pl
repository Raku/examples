use v6;

constant N = 1000;

# possible range of a
1..Int((1 - sqrt(0.5)) * N)

# compute numerator and denominator of closed expression for b
==> map -> \a { [ a, N * (N - 2 * a), 2 * (N - a) ] }

# check if closed expression yields an integer
==> grep -> [ \a, \u, \v ] { u %% v }

# compute b and c
==> map -> [ \a, \u, \v ] { my \b = u div v; [ a, b, N - a - b ] }

# compute product
==> map -> @triple { [*] @triple }

# print result
==> say;
