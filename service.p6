use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Cro::HTTP::Router;

my $application = route {
    get -> {
        static 'html/index.html';
    }
    get -> 'css', *@path { static 'html/css', @path; }
    get -> 'images', *@path { static 'html/images', @path; }
    get -> *@path {
        @path[*-1] ~= '.html' unless @path[*-1].ends-with('.html');
        static 'html', @path;
    }
}

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => 'localhost',
    port => 20000,
    :$application,
    after => [ Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR) ]
);
$http.start;

say "Listening at http://%*ENV<EXAMPLES_HOST>:%*ENV<EXAMPLES_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
