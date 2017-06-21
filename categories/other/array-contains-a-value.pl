=begin pod

=TITLE Determine whether an array contains a value

=AUTHOR Fyodor Sizov

DESCRIPTION

=head1 What's interesting here?

=item Use of "eq" operator and any(@array)
=item eq any(@arr) can be used both for strings and integers


=end pod

use v6;

my @arr = <the quick brown fox 5 2 9>;
say 'fox' eq any(@arr) ?? 'YES' !! 'NO'; # YES
say 'dog' eq any(@arr) ?? 'YES' !! 'NO'; # NO
say 3 eq any(@arr) ?? 'YES' !! 'NO'; # NO
say 2 eq any(@arr) ?? 'YES' !! 'NO'; # YES

# Local Variables:
# mode: perl6
# indent-tabs-mode: nil
# perl6-indent-offset: 4
# End:
# vim: expandtab shiftwidth=4 ft=perl6
