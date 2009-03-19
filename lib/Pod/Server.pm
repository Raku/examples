#!/usr/local/bin/perl6

use HTTP::Daemon;
use Pod::to::xhtml;
use Test::Mock::Parser;

class Xhtml::emitter is Pod::to::xhtml does Test::Mock::Parser {}

class Pod::Server is HTTP::Daemon {

    has $!request_line;
    has $!scheme;
    has $!server;
    has $!directory;
    has $!filename;
    has $!parameters;

    method server( $self: ) {
        my Str $host =      %*ENV<LOCALADDR>  // '127.0.0.1';
        my Int $port = int( %*ENV<LOCALPORT>  // '2080' );
        my Str $perl6 =     %*ENV<PERL6>      // 'perl6';
        say "Perl 6 (Rakudo) podserver listening at http://$host:$port";
        while Bool::True {
            # spawning netcat here is a temporary measure until Rakudo
            # gets socket(), listen(), accept() etc.
            run( "netcat -c '$perl6 $*PROGRAM_NAME rq' -l -s $host -p $port" );
        }
    }

    method request( $self: ) {
        $self.parse_request();
        my $path_links = $self.path_links.join(" /\n");
        my $pod = $self.getpod();
        say "{header()}<html>\n<head>\n{stylesheet()}\n</head>\n<body>";
        say "<h1>Pod::Server</h1>";
        say "Path: $path_links<br/>";
        say "File name: $!filename<br/>";
        say "<table><tr>";
        say "<td>\n{directory_list($!directory)}\n</td>";
#       say "<td id=\"pod\">hello</td>";
        say "<td id=\"pod\">$pod</td>";
        say "</tr></table>";
        say "</body>\n</html>";
    }

    grammar URL {
        regex TOP { <scheme> <server> <directory> <filename> <parameters> };
        regex scheme     { [ [ http | https ] '://' ] ? };
        regex server     { <- [/] > * };
        regex directory  { .* '/' };
        regex filename   { <- [?] > * };
        regex parameters { .* };
    }

    method parse_request( $self: ) {
        $!request_line = =$*IN;
        my Str $url = $!request_line.split(' ')[1];
        if $url ~~ / <Pod::Server::URL::TOP> / {
            $!scheme     = ~ $/<Pod::Server::URL::TOP><scheme>;
            $!server     = ~ $/<Pod::Server::URL::TOP><server>;
            $!directory  = ~ $/<Pod::Server::URL::TOP><directory>;
            $!filename   = ~ $/<Pod::Server::URL::TOP><filename>;
            $!parameters = ~ $/<Pod::Server::URL::TOP><parameters>;
            # if the name after the final / is a subdirectory, move the name
            if "$!directory$!filename" ~~ :d {
                $!directory ~= "$!filename";
                $!filename = '';
            }
            # if the directory is not / but ends in /, trim that ending /
            if $!directory ~~ / ( .+ ) \/ $ / { $!directory = ~ $0; }
#           warn "PARSE URL:    '$url'";
#           warn "PARSE SCHEME: '$!scheme'";
#           warn "PARSE SERVER: '$!server'";
#           warn "PARSE DIR:    '$!directory'";
#           warn "PARSE FILE:   '$!filename'";
#           warn "PARSE PARAM:  '$!parameters'";
        }        
    }

    method getpod {
        my $pod;
        if "$!directory/$!filename" ~~ :f {
            my Xhtml::emitter $podlator .= new;
            $podlator.parse_file( '/dev/null' ); # sorry, it's crufty,
            # but it's the easiest way to initialize the parser at runtime.
            # I promise to eradicate thsi soon -- mberends
            $pod = $podlator.parse( slurp("$!directory/$!filename") ).join("\n");
        }
        else {
            $pod = 'This is a directory. Click on another directory link,'
                 ~ ' or on a POD file name to see its contents.';
        }
        return $pod;
    }

    sub header() {
        return "HTTP/1.0 200 OK\n"
             ~ "Content-Type: text/html\n"
             ~ "\n";
    }

    method path_links {
#       warn "DIR: '$!directory'";
        my @directory_parts = $!directory.split( / <[/\\]> / ); #/
        if @directory_parts[0]   eq '' { @directory_parts.shift; }
        if @directory_parts[*-1] eq '' { @directory_parts.pop; }
        my $url = "";
        my @links = qq[<a href="/">(root)</a>];
        for @directory_parts -> $part {
            $url ~= "/$part";
            my $link = qq[<a href="$url">$part</a>];
            @links.push( $link );
        }
#       warn "LINKS: {@links}";
        return @links;
    }

    # Generate the list of directory contents for the left margin
    sub directory_list( Str $directory ) {
        my @names = glob( $directory eq '/' ?? "/*" !! "$directory/*" );
        my @subdirectories = grep { $_  ~~ :d }, @names.sort;
        my @files          = grep { $_ !~~ :d }, @names.sort;
#       warn "SUBDIR={@subdirectories}";
#       warn "FILES={@files}";
        my $html;
        for @subdirectories -> Str $name {
            if $name ~~ / ( .* ) \/ ( <-[\/]>+ ) / {
                my $parentdir = $0;
                my $child_dir = $1;
                $html ~= "<a href=\"$name\">$child_dir/</a><br/>\n";
            }
            else { die "directory_list bad dirname $name"; }
        }
        for @files -> Str $name {
            if $name ~~ / ( .* ) \/ ( <-[\/]>+ ) / {
                my $parentdir = $0;
                my $childfile = $1;
                $html ~= "<a href=\"$name\">$childfile</a><br/>\n";
            }
            else { die "directory_list bad filename $name"; }
        }
        return $html;
    }
}

sub stylesheet() {
    my $sheet = q[
h1 { font-family: Sans; }
table { }
td { vertical-align: top; }
td#pod { border-style: solid; width: 100%; }
];
    return "<style type=\"text/css\">$sheet</style>\n";
}

# inefficient workaround - remove when Rakudo gets a glob function
sub glob( Str $pattern ) {
    my Str $tempfile = "/tmp/per6-pod-server-glob.tmp";
    my Str $command = "ls -d $pattern >$tempfile 2>/dev/null";
    run $command;
    my @filenames = slurp($tempfile).split("\n");
#   warn "GLOB: {@filenames}";
    if @filenames[*-1] eq "" { pop @filenames; } # slurp may append an empty line that is not in the file
    unlink $tempfile;
    return @filenames;
}

# inefficient workaround - remove when Rakudo gets a qx operator
sub fake_qx( $command ) {
    my $tempfile = "/tmp/rakudo_qx.tmp";
    my $fullcommand = "$command >$tempfile";
    run $fullcommand;
    my $result = slurp( $tempfile );
    unlink $tempfile;
    return $result;
}

# finally, the main program
#if @*ARGS.elems == 0 { PodServer.new.server(); }  # run from command line
#else                 { PodServer.new.request(); } # run from netcat

=begin pod

=head1 SEE ALSO
HTTP 1.1 (L<http://www.ietf.org/rfc/rfc2616.txt>)

=end pod
