#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Writing a CGI Script

=AUTHOR stmuk

You want to write a simple CGI to parse a form and display it

(This example uses the more modern and faster variation PSGI and runs
standalone on localhost at port 8080 and depends on 'HTTP::Easy' and 'Web'
being installed from the ecosystem)

=end pod

use HTTP::Easy::PSGI;
use Web::Request;

my $http = HTTP::Easy::PSGI.new(:port(8080));

my $form = qq :to 'EOT';
<html>
  <form>
    Enter your name
    <input name="name" type="text">
    <input type="submit">
  </form>
</html>
EOT

# entry point
my $app = sub (%env) {
    my $req = Web::Request.new(%env);

    if !(my $name = $req.get('name')).so {
        # no CGI param passed so display form
        return [ 200, [ 'Content-Type' => 'text/html;charset=UTF-8' ], [ $form ]];
    }
    else {
        return [ 200, [ 'Content-Type' => 'text/html;charset=UTF-8' ], [ "<html>hello {$name}</html>" ] ];
    }
}

$http.handle($app);

# vim: expandtab shiftwidth=4 ft=perl6
