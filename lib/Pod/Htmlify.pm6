module Pod::Htmlify;

use URI::Escape;
use Pod::To::HTML;
use Pod::Convenience;
use Perl6::Examples;

class Website is export {
    has $.categories is rw;
    has $.base-html-dir is rw = "html";
    has $.base-categories-dir is rw = "categories";
    has %.examples-metadata;

    #| build the website
    method build {
        self.write-index;
        self.collect-all-metadata;
        self.write-category-indices;
        self.create-category-dirs;
        self.write-example-files;
    }

    #| write main index file
    method write-index {
        say "Creating main index file";
        spurt $!base-html-dir ~ '/index.html',
            self.p2h(EVAL slurp('lib/HomePage.pod') ~ "\n\$=pod");
    }

    #| collect metadata for all example files
    method collect-all-metadata {
        for $!categories.categories-list <-> $category {
            my $category-key = $category.key;
            my @files = files-in-category($category-key, base-dir => $!base-categories-dir);
            for @files -> $file {
                my $example = self.collect-example-metadata($file, $category-key);
                %!examples-metadata{$category-key}{$file.basename} = $example;
                $category.examples{$file.basename} = $example;
            }
            if $category.subcategories {
                for $category.subcategories.categories-list <-> $subcategory {
                    my $subcategory-key = $subcategory.key;
                    my $base-dir = $!base-categories-dir ~ "/" ~ $category-key;
                    my @files = files-in-category($subcategory-key,
                                                  base-dir => $base-dir);
                    for @files -> $file {
                        my $example = self.collect-example-metadata($file, $subcategory-key);
                        $subcategory.examples{$file.basename} = $example;
                    }
                }
            }
        }
    }

    #| collect metadata for a given example
    method collect-example-metadata($file, $category-key) {
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
                        filename => $file,
                        pod-link => $link,
                        pod-contents => $pod,
                        );

        return $example;
    }

    #| write index files for all categories
    method write-category-indices {
        say "Creating category index files";
        my @headers = qw{File Title Author};
        for $!categories.categories-table.kv -> $category, $title {
            my @examples = %!examples-metadata{$category}.values;
            my @rows = @examples.map: {[.pod-link, .title, .author]};
            spurt $!base-html-dir ~ "/$category.html", self.p2h(
                pod-with-title($title,
                    pod-table(@rows, headers => @headers),
                ),
            );
        }
    }

    #| create category and subcategory directories
    method create-category-dirs {
        for $!categories.categories-list -> $category {
            my $category-dir-name = $!base-html-dir ~ "/categories/" ~ $category.key;
            mkdir $category-dir-name unless $category-dir-name.IO.d;
            if $category.subcategories {
                for $category.subcategories.categories-list -> $subcategory {
                    my $subcat-dir-name ~= $category-dir-name ~ "/" ~ $subcategory.key;
                    mkdir $subcat-dir-name unless $subcat-dir-name.IO.d;
                }
            }
        }
    }

    #| write html pages for all examples
    method write-example-files {
        for $!categories.categories-list -> $category {
            my $category-key = $category.key;
            say "Creating example files for category: $category-key";
            my @files = files-in-category($category-key, base-dir => $!base-categories-dir);
            for @files -> $file {
                next unless $file.IO.e;
                my $example = %!examples-metadata{$category-key}{$file.IO.basename};
                my $pod = format-author-heading($example);
                $pod.push: source-reference($file, $category-key);
                my $html-file = $file.IO.basename.subst(/\.p(l|6)/, ".html");
                $html-file = $!base-html-dir ~ "/categories/$category-key/" ~ $html-file;
                spurt $html-file, self.p2h($pod);
            }
            if $category.subcategories {
                for $category.subcategories.categories-list -> $subcategory {
                    my $subcategory-key = $subcategory.key;
                    say "Creating example files for subcategory: $subcategory-key";
                    my $base-dir = $!base-categories-dir ~ "/" ~ $category-key;
                    my @files = files-in-category($subcategory-key, base-dir => $base-dir);
                    for @files -> $file {
                        next unless $file.IO.e;
                        my $example = $subcategory.examples{$file.IO.basename};
                        my $pod = format-author-heading($example);
                        $pod.push: source-reference($file, $subcategory-key);
                        my $html-file = $file.IO.basename.subst(/\.p(l|6)/, ".html");
                        $html-file = $!base-html-dir ~ "/categories/$category-key/$subcategory-key/" ~ $html-file;
                        spurt $html-file, self.p2h($pod);
                    }
                }
            }
        }
    }

    #| convert the POD into html
    method p2h($pod) {
        my $head = slurp 'template/head.html';
        my $footer = footer-html;
        pod2html $pod,
            :url(&url),
            :$head,
            :header(header-html $!categories.keys),
            :$footer,
            :default-title("Perl 6 Examples");
    }

}

sub files-in-category($category, :$base-dir = "./categories") {
    dir($base-dir ~ "/$category", test => rx{ <?!after 'p5'> \.p[l||6]$ }).sort;
}

sub url($url) {
    return $url;
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

# vim: expandtab shiftwidth=4 ft=perl6
