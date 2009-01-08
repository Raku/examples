class HTTP_Daemon
{
    has Str  $.host;
    has Int  $.port;
    has Bool $!running;
    has Str  $!temporary_prog;
    has Bool $!accepted;

    method daemon {
        $!running = Bool::True;
        while $!running {
#           my Str $command = "$*PROG --request";
            my Str $command = "{$!temporary_prog} --request";
            run( "netcat -c '$command' -l -s {$.host} -p {$.port}" );
            # spawning netcat here is a temporary measure until
            # Rakudo gets socket(), listen(), accept() etc.
        }
    }

    method temporary_set_prog( Str $prog ) {
        $!temporary_prog = $prog;
    }

    method url {
        return "http://{$.host}:{$.port}";
    }

    method accept {
        if defined $!accepted { return undef; }
        else {
            $!accepted = Bool::True;
            my HTTP_Daemon_ClientConn $clientconn .= new;
            return $clientconn;
        }
    }
}

class HTTP_Daemon_ClientConn {
    has HTTP_Request $.request is rw;
    has Bool $!gave_request;
    
    method get_request {
        if defined $!gave_request { return undef; }
        else {
            $!gave_request = Bool::True;
            my Str $line = =$*IN;
            my @fields = $line.split(' ');
            my HTTP_Request $request .= new(
                req_url=> HTTP_url.new( path=>@fields[1] )
            );
            $request.method = @fields[0];
            return $request;
        }
    }

    method send_basic_header {
        self.send_status_line;
    }

    multi method send_status_line(
        Int $status?   = 200,
        Str $message?  = 'OK',
        Str $protocol? = 'HTTP/1.0'
    ) { say "$protocol $status $message"; }

    method send_crlf {
        say "";
    }

    method send_response( Str $content ) {
        self.send_basic_header;
        self.send_crlf;
        say $content;
    }

    method send_file_response( Str $filename ) {
        self.send_basic_header;
        self.send_crlf;
        self.send_file( $filename );
    }

    method send_file( Str $filename ) {
        my $contents = slurp( $filename );
        print $contents;
    }

    multi method send_error( Int $status ) {
        my %message = (
            200 => 'OK',
            403 => 'RC_FORBIDDEN',
            404 => 'RC_NOTFOUND',
            500 => 'RC_INTERNALERROR',
            501 => 'RC_NOTIMPLEMENTED'
        );
        self.send_error( $status, %message{$status} );
    }

    multi method send_error( Str $message ) {
        my %status = (
            'OK'                => 200,
            'RC_FORBIDDEN'      => 403,
            'RC_NOTFOUND'       => 404,
            'RC_INTERNALERROR'  => 500,
            'RC_NOTIMPLEMENTED' => 501
        );
        self.send_error( %status{$message}, $message );
    }

    multi method send_error( Int $status, Str $message ) {
        self.send_status_line( $status, $message );
        self.send_crlf;
        say "<title>$status $message</title>";
        say "<h1>$status $message</h1>";
    }
}

class HTTP_Request {
    has Str      $.method  is rw;
    has HTTP_url $.req_url is rw;
    method url {
        return $.req_url;
    }
}

class HTTP_url {
    has $.path;
}

class HTTP_Response {
}

=begin pod

=head1 NAME
HTTP::Daemon - a (very) simple web server using Rakudo Perl 6

=head1 SYNOPSIS
#!/usr/local/bin/perl6

use v6;
use HTTP_Daemon;
defined @*ARGS[0] && @*ARGS[0] eq '--request' ?? request() !! daemon();

sub request {
    my HTTP_Daemon $d .= new;
    while my HTTP_Daemon_ClientConn $c = $d.accept {
        while my HTTP_Request $r = $c.get_request {
            my $method = $r.method;
            if $r.method eq 'GET' {
                given $r.url.path {
                    when '/'             { get_root_dir( $c, $r ); }
                    when / ^ \/pub\/ $ / { get_pub_dir(  $c, $r ); }
                }
            }
            else {
                $c.send_error('RC_FORBIDDEN');
            }
        }
    }
}
sub get_root_dir( HTTP_Daemon_ClientConn $c, HTTP_Request $r ) {
    my $content = q[<html><head><title>Hello</title>
<body><h1>Rakudo web server</h1>
Hello, world! This is root. Go to <a href="/pub/">pub</a>.
</body></html>];
    $c.send_response( $content );
}
sub get_pub_dir( HTTP_Daemon_ClientConn $c, HTTP_Request $r ) {
    my $content = q[<html><head><title>Hello</title>
<body><h1>Rakudo web server</h1>
Hello again, this is pub. Go <a href="/">Home</a>.
</body></html>];
    $c.send_response( $content );
}
=begin code
=end code
or, the Perl 5 L<doc:HTTP::Daemon> example converted:
=begin code
#!/usr/local/bin/perl6

use v6;
use HTTP_Daemon;
defined @*ARGS[0] && @*ARGS[0] eq '--request' ?? request() !! daemon();

sub request {
    my HTTP_Daemon $d .= new;
    while my HTTP_Daemon_ClientConn $c = $d.accept {
        while my HTTP_Request $r = $c.get_request {
            if $r.method eq 'GET' and $r.url.path eq '/xyzzy' {
                # remember, this is *not* recommended practice :-)
                $c.send_file_response("/etc/passwd");
            }
            else {
                $c.send_error('RC_FORBIDDEN');
            }
        }
    }
}

sub daemon {
    my HTTP_Daemon $d .= new( host=>'127.0.0.1', port=>2080 );
    $d.temporary_set_prog( './test.pl' );
    say "Browse this Perl 6 web server at {$d.url}";
    $d.daemon();
}

=head1 DEPENDENCIES
Temporarily (see L<#TODO>) HTTP_Daemon depends on the L<man:netcat>
utility to receive and send on a TCP port.
On Debian based Linux distributions, this should set it up:

 sudo apt-get install netcat

=head1 TODO
Remove temporary_set_prog() when rakudo gets $*PROG.

=head1 SEE ALSO
L<man:netcat>
HTTP 1.1 (L<http://www.ietf.org/rfc/rfc2616.txt>) includes all methods
and status codes.

=end pod
