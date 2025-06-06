=begin pod

=TITLE Combinations

=AUTHOR Filip Sergot

Prints all the combinations of items from the given array.

=head1 What's interesting here?

=item multi subroutines
=item shortened use of $_ variable
=item placeholder variables

=head1 Features used

=item C<Placeholder variables> - L<https://doc.perl6.org/language/variables>

=end pod

use v6;

multi combs(@, 0) { "" };
multi combs { combs(@^dict, $^n - 1) X~ @dict };

(.say for combs(<a b c>, $_)) for 1..4;

# vim: expandtab shiftwidth=4 ft=perl6
