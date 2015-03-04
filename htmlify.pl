use v6;

use lib 'lib';
use Pod::To::Perl;
use Pod::To::HTML;
use Pod::Htmlify;
use Pod::Convenience;

my $head = slurp 'template/head.html';
my $footer = footer-html;
sub header-html(%categories) {
    my $header = slurp 'template/header.html';
    my $menu-items = [~]
        q[<div class="menu-items dark-green">],
        %categories.keys.map( -> $category {qq[
            <a class="menu-item selected darker-green"
                href="/$category.html">
                { $category.wordcase }
            </a>
        ]}),
        q[</div>];
    my $menu-pos = ($header ~~ /MENU/).from;
    $header.subst('MENU', :p($menu-pos), $menu-items);
}

my %categories =
    "best-of-rosettacode" => "Best of Rosettacode",
    "99-problems"         => "99 problems",
    "cookbook"            => "Cookbook examples",
    "euler"               => "Answers for Project Euler",
    "games"               => "Games written in Perl 6",
    "interpreters"        => "Language or DSL interpreters",
    "parsers"             => "Example grammars",
    "perlmonks"           => "Answers to perlmonks.org questions",
    "rosalind"            => "Bioinformatics programming problems",
    "shootout"            => "The Computer Language Benchmark Game",
    "tutorial"            => "Tutorial examples",
    "wsg"                 => "The Winter Scripting Games",
    "other"               => "Uncategorized examples",
;

write-index;
write-index-files(%categories);
create-category-dirs(%categories);
write-example-files(%categories);

sub write-index {
    say "Creating main index file";
    spurt 'html/index.html', p2h EVAL slurp('lib/HomePage.pod') ~ "\n\$=pod";
}

sub write-index-files(%categories) {
    say "Creating category index files";
    for %categories.kv -> $category, $title {
        my @files = files-in-category($category);
        my @filenames = @files.map: {.basename};
        my @pod-links = @filenames.map: {pod-link($_, "categories/$category/$_")};
        spurt "html/$category.html", p2h(
            pod-with-title($title,
                pod-table(@pod-links),
            ),
        );
    }
}

sub files-in-category($category) {
    dir("categories/$category", test => rx{ <?!after 'p5'> \.p[l||6]$ }).sort;
}

sub create-category-dirs(%categories) {
    for %categories.keys -> $category {
        my $dir-name = "html/categories/$category";
        mkdir $dir-name unless $dir-name.IO.d;
    }
}

sub write-example-files(%categories) {
    for %categories.keys -> $category {
        say "Creating example files for category: $category";
        my @files = files-in-category($category);
        my @filenames = @files.map: {.basename};
        for @files -> $file {
            next unless $file.IO.e;
            my $perl-pod = qqx{perl6-m -Ilib --doc=Perl $file};
            my $pod = EVAL $perl-pod;
            if !$pod {
                my @contents = $file.lines.join("\n");
                $pod = Array.new(pod-with-title($file.basename,
                    pod-code(@contents),
                ));
            }
            else {
                my $title-element = $pod[0].contents[0];
                if $title-element ~~ Pod::Block::Named && $title-element.name eq "TITLE" {
                    my $title = $title-element.contents[0].contents[0];
                    say $title;
                }
                else {
                    say "$file lacks a TITLE";
                }
            }
            $pod.push: source-reference($file, $category);
            my $html-file = $file.subst(/\.p(l|6)/, ".html");
            spurt "html/$html-file", p2h($pod);
        }
    }
}

sub source-reference($file, $category) {
    pod-block("Source code: ",
        pod-link($file.basename,
            "https://github.com/perl6/perl6-examples/blob/master/categories/$category/" ~ $file.basename),
    );
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
