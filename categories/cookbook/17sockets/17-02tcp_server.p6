#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Writing a TCP Server

=AUTHOR stmuk

You want to write a TCP Server to listen on a socket

=end pod

my $s = IO::Socket::INET.new( :localport(1024), :type(1), :reuse(1),
                              :listen(10));

while my $c = $s.accept()  {
    say $c.get;
}

# vim: expandtab shiftwidth=4 ft=perl6
