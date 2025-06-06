use v6;

=begin pod

=TITLE Binomial Coefficient

=AUTHOR L. Grondin

Number of ways to choose P objects among N.  It's also the coefficient of the
monome of degree P in the expansion of (1 + X)^N, thus the name.


     N       (N-P+1)*(N-P+2)*...*N
   (   ) = ∑ -------------------
     P         1*2*...*P


=head1 More

L<http://rosettacode.org/wiki/Evaluate_binomial_coefficients#Raku>

=head1 Notable features used

=item infix sub definition
=item reduction meta-operator
=item self-declared parameters
=item sequence operator to get a decreasing order
=item Zip metaoperator with list of different sizes
=item use of rational numbers as a default

=end pod

sub infix:<choose> { [*] ($^n ... 0) Z/ 1 .. $^p }

say 5 choose 3;

# vim: expandtab shiftwidth=4 ft=perl6
