use v6;

=begin pod

=TITLE send a signal

=AUTHOR stmuk

You want to send a signal to a process on a UNIX-like OS

=end pod

use NativeCall;

sub kill(Int,Int) returns Int is native { ... }

signal(SIGHUP).tap( {say "caught HUP"});

kill($*PID, Signal::SIGHUP);

sleep 2;

# vim: expandtab shiftwidth=4 ft=perl6
