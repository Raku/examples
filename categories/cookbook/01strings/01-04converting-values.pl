use v6;

=begin pod

=TITLE Converting between characters and numbers.

=AUTHOR Scott Penrose

You want to convert characters to their numeric value or vice-versa

=end pod

# XXX I'm not sure "numeric value" is still correct for utf-8, as the actual
# value(s) in memory can be very different. Maybe use "codepoint", or "codepoint
# number"?

my $char = 'a';
my $num  = $char.ord;
say $num;
my $char2 = $num.chr;
say $char2;

$char = 'foo';
say $char.ord; # XXX is this correct behavior?

# vim: expandtab shiftwidth=4 ft=perl6
