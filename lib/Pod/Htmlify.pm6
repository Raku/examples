module Pod::Htmlify;

use URI::Escape;
use Pod::To::HTML;
use Pod::Convenience;
use Perl6::Examples;

class Website is export {
    has $.categories is rw;

    method create-category-dirs(:$base-dir = "html/categories/") {
        for $!categories.categories-list -> $category {
            my $category-dir-name = $base-dir ~ "/" ~ $category.key;
            mkdir $category-dir-name unless $category-dir-name.IO.d;
            for $category.subcategories -> $subcategory {
                my $subcat-dir-name ~= $category-dir-name ~ "/" ~ $subcategory.key;
                mkdir $subcat-dir-name unless $subcat-dir-name.IO.d;
            }
        }
    }

    method write-index(:$base-dir = "html/") {
        say "Creating main index file";
        spurt $base-dir ~ '/index.html', p2h EVAL slurp('lib/HomePage.pod') ~ "\n\$=pod";
    }

    method write-category-indices(%examples, :$base-dir = "html/") {
        say "Creating category index files";
        my @headers = qw{File Title Author};
        for $!categories.categories-table.kv -> $category, $title {
            my @examples = %examples{$category}{""}.values;
            my @rows = @examples.map: {[.pod-link, .title, .author]};
            spurt $base-dir ~ "/$category.html", p2h(
                pod-with-title($title,
                    pod-table(@rows, headers => @headers),
                ),
            );
        }
    }
}

sub header-html(@category-keys) {
    my $header = slurp 'template/header.html';
    my $menu-items = [~]
        q[<div class="menu-items dark-green">],
        @category-keys.map( -> $category {qq[
            <a class="menu-item selected darker-green"
                href="/$category.html">
                { $category.wordcase.subst('-', ' ', :global) }
            </a>
        ]}),
        q[</div>];
    my $menu-pos = ($header ~~ /MENU/).from;
    $header.subst('MENU', :p($menu-pos), $menu-items);
}

sub footer-html {
    my $footer = slurp 'template/footer.html';
    $footer.subst('DATETIME', ~DateTime.now);
}

sub files-in-category($category) {
    dir("categories/$category", test => rx{ <?!after 'p5'> \.p[l||6]$ }).sort;
}

sub collect-example-metadata($categories) is export {
    my %examples;
    for $categories.categories-list -> $category, {
        my $subcategory = "";
        my $category-key = $category.key;
        my @files = files-in-category($category-key);
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
            my $link = pod-link($file-basename, "categories/$category-key/$file-basename");
            my $example = Example.new(
                            title => $example-title,
                            author => $author,
                            category => $category-key,
                            subcategory => $subcategory,
                            filename => $file,
                            pod-link => $link,
                            pod-contents => $pod,
                            );
            %examples{$category-key}{$subcategory}{$file} = $example;
        }
    }

    return %examples;
}

sub write-example-files(%examples) is export {
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

sub p2h($pod) {
    my $head = slurp 'template/head.html';
    my $footer = footer-html;
    pod2html $pod,
        :url(&url),
        :$head,
        :header(header-html %categories.keys),
        :$footer,
        :default-title("Perl 6 Examples");
}

sub url($url) {
    return $url;
}

# vim: expandtab shiftwidth=4 ft=perl6
