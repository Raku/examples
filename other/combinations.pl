=begin pod

=head1 Combinations

Prints all the combinations of items from given array.

=head1 What's interesting here?

=item multi subroutines
=item shortened use of $_ variable
=item placeholder variables

=end pod

use v6;

multi combs(@, 0) { "" };
multi combs { combs(@^dict, $^n - 1) X~ @dict };
 
(.say for combs(<a b c>, $_)) for 1..4;

=begin pod

=head1 Features used

=item C<Placeholder variables> - L<http://perlcabal.org/syn/S06.html#Placeholder_variables>

=end pod
