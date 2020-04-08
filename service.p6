use MONKEY-SEE-NO-EVAL;
use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Pod::To::HTML;
use Raku::Highlight;

my $categories = (
        { :url<best-of-rosettacode>, :full-name("Best of Rosettacode"),
        :short-name("Rosettacode"), :desc("The best of the rosettacode.org examples") },
        { :url<99-problems>, :full-name("99 Problems"),
        :short-name("99 Problems"), :desc("Based on lisp 99 problems") },
        { :url<cookbook>, :full-name("Cookbook examples"),
        :short-name("Cookbook"), :desc("Cookbook examples") },
        { :url<euler>, :full-name("Project Euler"),
        :short-name("Euler"), :desc("Answers for Project Euler") },
        { :url<games>, :full-name("Games"),
        :short-name("Games"), :desc("Games written in Raku") },
        { :url<interpreters>, :full-name("Interpreters"),
        :short-name("Interpreters"), :desc("Language or DSL interpreters") },
        { :url<module-management>, :full-name("Module management"),
        :short-name("Modules"), :desc("Examples of organising modules") },
        { :url<parsers>, :full-name("Parsers"),
        :short-name("Grammars"), :desc("Example grammars") },
        { :url<perlmonks>, :full-name("Perlmonks"),
        :short-name("Perlmonks"), :desc("Answers to perlmonks.org questions") },
        { :url<rosalind>, :full-name("Project Rosalind"),
        :short-name("Rosalind"), :desc("Bioinformatics-related programming problems") },
        { :url<shootout>, :full-name("Shootout"),
        :short-name("Shootout"), :desc("Implementations for the Computer Language Benchmark Game") },
        { :url<tutorial>, :full-name("Raku Tutorial Examples"),
        :short-name("Tutorial"), :desc("Initial work in collecting Raku tutorial examples") },
        { :url<wsg>, :full-name("Winter Scripting Games"),
        :short-name("WSG"), :desc("Answers for the Winter Scripting Games") },
        { :url<other>, :full-name("Other examples"),
        :short-name("Other"), :desc("Other examples which aren't yet categorized") }).sort(*.<short-name>).cache;

sub pod-title-contents($pod, $file) is export {
    my $title-element = $pod[0].contents[0];
    my $title = "";
    if $title-element ~~ Pod::Block::Named && $title-element.name eq "TITLE" {
        try {
            $title = $title-element.contents[0].contents[0];
            CATCH {
                default { $title = "TITLE is empty" }
            }
        }
    }
    else {
        say "$file lacks a TITLE";
    }

    $title;
}

sub pod-author-contents($pod, $file) is export {
    my $author-element = $pod[0].contents[1];
    my $author = "";
    if $author-element ~~ Pod::Block::Named && $author-element.name eq "AUTHOR" {
        try {
            $author = $author-element.contents[0].contents[0];
            CATCH {
                default { $author = "AUTHOR is empty" }
            }
        }
    }
    else {
        say "$file lacks an AUTHOR";
    }

    $author;
}

my %example-cache;

sub obtain-category-files($category) {
    return $_ with %example-cache{$category};
    my @files = dir "categories/$category", test => { .Str.ends-with('.pl') || .Str.ends-with('p6') };
    my %result;
    race for @files.sort(*.basename) -> $file {
        my $pod-collector = run $*EXECUTABLE.absolute, '-Ilib', '--doc=Perl', $file.Str, :out;
        my $perl-pod = $pod-collector.out.slurp(:close);
        my $file-basename = $file.basename;
        my $pod = EVAL $perl-pod;
        my $title = pod-title-contents($pod, $file-basename);
        my $author = pod-author-contents($pod, $file-basename);
        my $filename = $file.basename;
        my $url = "/categories/$category/$filename";
        %result{$filename} = { :$title, :$author, :$url, :$filename, :$pod, example => slurp $file.Str }
    }
    %example-cache{$category} = %result;
}

sub form-example-preface($pod) {
    Pod::To::HTML.render($pod);
}
sub form-example-code($example) {
    my $code = $example.split("=end pod\n")[1];
    Raku::Highlight.highlight($code);
}

my $application = route {
    template-location 'template/';

    get -> {
        template 'index.crotmp', { :$categories }
    }

    get -> 'css', *@path { static 'html/css', @path; }
    get -> 'images', *@path { static 'html/images', @path; }

    # Main handler
    get -> 'categories', $category {
        my $title = $categories.first(*<url> eq $category)<full-name>;
        my $category-files = obtain-category-files($category).values;
        with $title {
            template 'category.crotmp', { :$categories, :$title, :$category-files };
        } else { not-found }
    }

    get -> 'categories', $category, $example-path {
        my $path = "categories/$category/$example-path";
        my $title = $categories.first(*<url> eq $category)<full-name>;
        with $title {
            if $path.IO.e {
                with %example-cache{$category} {
                    with $_{$example-path} {
                        my $pod = $_<pod>;
                        my $example = $_<example>;
                        my $preface = form-example-preface($pod);
                        my $code = form-example-code($example);
                        template 'example.crotmp', { :$categories, :title($example-path), :$preface, :$code }
                    }
                } else {

                }
            } else { not-found }
        } else { not-found }
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
