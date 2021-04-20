use v6;

=begin pod

=TITLE 100 Doors

=AUTHOR TimToady

You have 100 doors in a row that are all initially closed. You make 100 passes
by the doors. The first time through, you visit every door and toggle the door
(if the door is closed, you open it; if it is open, you close it). The second
time you only visit every 2nd door (door #2, #4, #6, ...).  The third time,
every 3rd door (door #3, #6, #9, ...), etc, until you only visit the 100th
door.

=head1 Task

What state are the doors in after the last pass? Which are open,
which are closed?

=head1 More

L<http://rosettacode.org/wiki/100_doors#Raku>

=head1 Features used

C<X**> - L<http://doc.perl6.org/language/operators#Cross_Operators>

=end pod

say "Door $_ is open" for 1..10 X** 2;

# vim: expandtab shiftwidth=4 ft=perl6
