#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Writing a TCP Client

=AUTHOR stmuk

You want to connect to a socket on a remote host

=end pod

my $s = IO::Socket::INET.new( :host<www.perl6.org>, :port(80) );
$s.print( "HEAD / HTTP/1.0\r\n\r\n" );

while my $r = $s.get {
    say $r;
}

# vim: expandtab shiftwidth=4 ft=perl6
