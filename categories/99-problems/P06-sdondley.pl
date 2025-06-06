use v6;

=begin pod

=TITLE P06 - Find out whether a list is a palindrome.

=AUTHOR Steve Dondley

Specification:

    P06 (*) Find out whether a list is a palindrome.
    A palindrome can be read forward or backward; e.g. <x a m a x>.

=head1 What's interesting here?

The subroutine does a comparison between the passed array and the reversed
array using the C<eqv> operator. For the comparsion to work, both sides must be
the have the same object types. In this case, we are comparing C<Seq> objects.

The C<.flat> method is applied to the original array to return a Seq object
which gets compared to the Seq object returned by C<.reverse> method.

=head2 Features used

=item C<eqv> - L<https://docs.raku.org/routine/eqv|infix eqv>
=item C<flat> - L<https://docs.raku.org/routine/reverse|routine flat>
=item C<reverse> - L<https://docs.raku.org/routine/reverse|routine reverse>

=end pod

sub is-palindrome(*@list) {
    @list.flat eqv @list.reverse;
}

say is-palindrome(<1 2 1>); # yup
say is-palindrome(<1 2 3>); # nope

# vim: expandtab shiftwidth=4 ft=perl6
