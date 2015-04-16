use v6;

=begin pod
=head1 Writing a TCP Client

You want to connect to a socket on a remote host

=end pod

my $s = IO::Socket::INET.new( :host<www.perl6.org>, :port(80) );
$s.send( "HEAD / HTTP/1.0\n\n" );

while ( my $r = $s.get ) {
    say $r;
}


# vim: expandtab shiftwidth=4 ft=perl6
