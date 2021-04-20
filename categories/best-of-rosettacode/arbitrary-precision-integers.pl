use v6;

=begin pod

=TITLE Arbitrary-precision integers (included)

=AUTHOR TimToady

Using the in-built capabilities of your language, calculate the integer
value of:

    5^{4^{3^2}}

Confirm that the first and last twenty digits of the answer are:
62060698786608744707...92256259918212890625

Find and show the number of decimal digits in the answer.

=head1 More

L<http://rosettacode.org/wiki/Arbitrary-precision_integers_(included)#Raku>

=head1 What's interesting here?

=item metaoperator
=item casting
=item {} in string

=end pod

my $x = ~[**] 5, 4, 3, 2;
say "5**4**3**2 = {substr($x,0,20)}...{substr($x,$x.chars-20)} and has {$x.chars} digits";

# vim: expandtab shiftwidth=4 ft=perl6
