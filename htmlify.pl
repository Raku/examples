use v6;

use lib 'lib';
use Pod::To::Perl;
use Pod::To::HTML;
use Pod::Htmlify;
use Pod::Convenience;
use Perl6::Examples;

my $head = slurp 'template/head.html';
my $footer = footer-html;

my %categories =
    "best-of-rosettacode" => "Best of Rosettacode",
    "99-problems"         => "99 problems",
    "cookbook"            => "Cookbook examples",
    "euler"               => "Answers for Project Euler",
    "games"               => "Games written in Perl 6",
    "interpreters"        => "Language or DSL interpreters",
    "module-management"   => "Module management",
    "parsers"             => "Example grammars",
    "perlmonks"           => "Answers to perlmonks.org questions",
    "rosalind"            => "Bioinformatics programming problems",
    "shootout"            => "The Computer Language Benchmark Game",
    "tutorial"            => "Tutorial examples",
    "wsg"                 => "The Winter Scripting Games",
    "other"               => "Uncategorized examples",
;

my %examples = collect-example-metadata(%categories);

write-index;
write-index-files(%categories);
create-category-dirs(%categories);
write-example-files(%examples);

sub write-index {
    say "Creating main index file";
    spurt 'html/index.html', p2h EVAL slurp('lib/HomePage.pod') ~ "\n\$=pod";
}

sub write-index-files(%categories) {
    say "Creating category index files";
    my @headers = qw{File Title Author};
    for %categories.kv -> $category, $title {
        my @examples = %examples{$category}{""}.values;
        my @rows = @examples.map: {[.pod-link, .title, .author]};
        spurt "html/$category.html", p2h(
            pod-with-title($title,
                pod-table(@rows, headers => @headers),
            ),
        );
    }
}

sub write-example-files(%examples) {
    my @categories = %examples.keys;
    for @categories -> $category {
        say "Creating example files for category: $category";
        my @files = files-in-category($category);
        my @filenames = @files.map: {.basename};
        for @files -> $file {
            next unless $file.IO.e;
            my $example = %examples{$category}{""}{$file};
            my $pod = format-author-heading($example);
            $pod.push: source-reference($file, $category);
            my $html-file = $file.subst(/\.p(l|6)/, ".html");
            spurt "html/$html-file", p2h($pod);
        }
    }
}

sub p2h($pod) {
    pod2html $pod,
        :url(&url),
        :$head,
        :header(header-html %categories),
        :$footer,
        :default-title("Perl 6 Examples");
}

sub url($url) {
    return $url;
}

# vim: expandtab shiftwidth=4 ft=perl6
