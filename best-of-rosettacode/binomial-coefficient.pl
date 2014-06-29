=begin pod

=head1 Binomial Coefficient

Number of ways to choose P objects among N.  It's also the coefficient of the
monome of degree P in the expansion of (1 + X)^N, thus the name.


     N       (N-P+1)*(N-P)*...*N
   (   ) = ∑ -------------------
     P         1*2*...*P


=head1 More

L<http://rosettacode.org/wiki/Evaluate_binomial_coefficients#Perl_6>

=head1 Notable features used

=item infix sub definition
=item reduction meta-operator
=item self-declared parameters
=item range operator with first value excluded
=item Zip metaoperator with an infinite list on the right side
=item use of rational numbers as a default

=end pod

sub infix:<choose> { [*] $^n - $^p ^.. $n Z/ 1 .. * }
 
say 5 choose 3;
