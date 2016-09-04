use v6;

=begin pod

=TITLE Change text colour

=AUTHOR stmuk

Change text colour on a terminal

=end pod

use Term::ANSIColor;

print color("red"), "Danger, Will Robinson!\n", color("reset");

# vim: expandtab shiftwidth=4 ft=perl6
