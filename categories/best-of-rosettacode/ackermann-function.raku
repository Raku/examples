use v6;

=begin pod

=TITLE Ackermann function

=AUTHOR Filip Sergot

The Ackermann function is a classic recursive example in computer science.

=head1 More

L<http://rosettacode.org/wiki/Ackermann_function#Raku>

=head1 What's interesting here?

=item ternary chaining
=item recursive functions

=head1 Features used

=item C<ternary operator> - L<http://doc.perl6.org/language/operators#infix_%3F%3F_%21%21>
=item C<multi subs> - L<http://doc.perl6.org/syntax/multi>

=end pod

sub A(Int $m, Int $n) {

    $m == 0  ??    $n + 1                   !!
    $n == 0  ??  A($m - 1, 1            )   !!
                 A($m - 1, A($m, $n - 1));

}
A(1, 2).say;

# vim: expandtab shiftwidth=4 ft=perl6
