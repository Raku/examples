=begin pod

=head1 Ackermann function

 The Ackermann function is a classic recursive example in computer science.

=head1 More

L<http://rosettacode.org/wiki/Ackermann_function#Perl_6>

=head1 What's interesting here?

=item ternary chaining
=item recursive funtion

=end pod

sub A(Int $m, Int $n) {
 
    $m == 0  ??    $n + 1                   !! 
    $n == 0  ??  A($m - 1, 1            )   !!
                 A($m - 1, A($m, $n - 1));
 
}
A(1, 2).say;

=begin pod

=head1 Features used

=item C<ternary operator> - L<http://perlcabal.org/syn/S03.html#Conditional_operator_precedence>
=item C<multi subs> - L<http://perlcabal.org/syn/S12.html#Multisubs_and_Multimethods>

=end pod
