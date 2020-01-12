#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE A TCP server and a client

You create a TCP echo server and a client to it.

=end pod

# A client will try to connect in 0.1 seconds, send a line, receive one and exit
Promise.in(0.1).then({
    my $conn = IO::Socket::INET.new(:host<localhost>, :port(3333));
    $conn.print: 'Hello, Raku';
    say $conn.recv;
    $conn.close;
    exit 0;
});

# A server listens for connections and does echo
my $listen = IO::Socket::INET.new(:listen, :localhost<localhost>, :localport(3333));
loop {
    my $conn = $listen.accept;
    try {
        while my $buf = $conn.recv(:bin) {
            $conn.write: $buf;
        }
    }
    $conn.close;

    CATCH {
          default { .payload.say; }
    }
}
