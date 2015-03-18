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

sub collect-example-metadata(%categories) {
    my %examples;
    for %categories.kv -> $category, $category-title {
        my $subcategory = "";
        my @files = files-in-category($category);
        my @filenames = @files.map: {.basename};
        for @files -> $file {
            say "Collecting metadata from $file";
            my $perl-pod = qqx{perl6-m -Ilib --doc=Perl $file};
            my $pod = EVAL $perl-pod;
            my $file-basename = $file.basename;
            if !$pod {
                my @contents = $file.lines.join("\n");
                $pod = Array.new(pod-with-title($file-basename,
                    pod-code(@contents),
                ));
            }
            my $example-title = pod-title-contents($pod, $file-basename);
            my $author = pod-author-contents($pod, $file-basename);
            my $link = pod-link($file-basename, "categories/$category/$file-basename");
            my $example = Example.new(
                            title => $example-title,
                            author => $author,
                            category => $category,
                            subcategory => $subcategory,
                            filename => $file,
                            pod-link => $link,
                            pod-contents => $pod,
                            );
            %examples{$category}{$subcategory}{$file} = $example;
        }
    }

    return %examples;
}

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

sub files-in-category($category) {
    dir("categories/$category", test => rx{ <?!after 'p5'> \.p[l||6]$ }).sort;
}

sub create-category-dirs(%categories) {
    for %categories.keys -> $category {
        my $dir-name = "html/categories/$category";
        mkdir $dir-name unless $dir-name.IO.d;
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

sub format-author-heading($example) {
    my $pod = $example.pod-contents;
    if $example.author {
        my $author-heading = Pod::FormattingCode.new(:type<I>,
                                contents => ["Author: " ~ $example.author]);
        $example.pod-contents[0].contents[1] = pod-block([$author-heading]);
    }

    return $pod;
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
