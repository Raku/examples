use v6;

use lib 'lib';
use Pod::To::Perl;
use Pod::To::HTML;
use Pod::Htmlify;
use Pod::Convenience;

my $head = slurp 'template/head.html';
my $footer = footer-html;
my $header = slurp 'template/header.html';

my %categories =
    "best-of-rosettacode" => "Best of Rosettacode",
    "99-problems" => "99 problems",
    "cookbook" => "Cookbook examples",
    "euler" => "Answers for Project Euler",
    "games" => "Games written in Perl 6",
    "interpreters" => "Language or DSL interpreters",
    "parsers" => "Example grammars",
    "perlmonks" => "Answers to perlmonks.org questions",
    "rosalind" => "Bioinformatics programming problems",
    "shootout" => "Implementations for the Computer Language Benchmark Game",
    "wsg" => "Answers for the Winter Scripting Games",
    "other" => "Other examples which aren't yet categorized",
;

write-index;
write-index-files(%categories);
create-category-dirs(%categories);
write-example-files(%categories);

sub write-index {
    spurt 'html/index.html', p2h EVAL slurp('lib/HomePage.pod') ~ "\n\$=pod";
}

sub write-index-files(%categories) {
    for %categories.kv -> $category, $title {
        my @files = dir("categories/$category", test => /\.p(l|6)$/);
        my @filenames = @files.map: {.basename};
        my @pod-links = @filenames.map: {pod-link($_, "categories/$category/$_")};
        spurt "html/$category.html", p2h(
            pod-with-title($title,
                pod-table(@pod-links),
            ),
        );
    }
}

sub create-category-dirs(%categories) {
    for %categories.keys -> $category {
        my $dir-name = "html/categories/$category";
        mkdir $dir-name unless $dir-name.IO.d;
    }
}

sub write-example-files(%categories) {
    for %categories.keys -> $category {
        my @files = dir("categories/$category", test => /\.p(l|6)$/);
        my @filenames = @files.map: {.basename};
        for @files -> $file {
            next unless $file.IO.e;
            my $perl-pod = qqx{perl6-m -Ilib --doc=Perl $file};
            my $pod = EVAL $perl-pod;
            my $html-file = $file.subst(/\.p(l|6)/, ".html");
            spurt "html/$html-file", p2h($pod);
        }
    }
}

sub p2h($pod) {
    pod2html $pod,
        :url(&url),
        :$head,
        :header($header),
        :$footer,
        :default-title("Perl 6 Examples");
}

sub url($url) {
    return $url;
}

# vim: expandtab shiftwidth=4 ft=perl6
