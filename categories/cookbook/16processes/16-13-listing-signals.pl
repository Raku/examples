use v6;

=begin pod

=TITLE List Signals

=AUTHOR stmuk

You want to list the signals available on a UNIX-like OS

=end pod

# shamelessly stolen from a test
#
my @signals = $*KERNEL.signals.grep(Signal);

say :@signals.perl;

# vim: expandtab shiftwidth=4 ft=perl6
