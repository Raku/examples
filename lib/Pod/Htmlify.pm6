module Pod::Htmlify;

use URI::Escape;
use Pod::To::HTML;
use Pod::Convenience;
use Perl6::Examples;

class Website is export {
    has $.categories is rw;
    has $.base-html-dir is rw = "html";
    has $.base-categories-dir is rw = "categories";
    has %.menu-tabs;

    submethod BUILD(:$categories) {
        $!categories = $categories;
        for $categories.keys -> $category-key {
            %!menu-tabs{$category-key ~ ".html"} =
                $category-key.wordcase.subst('-', ' ', :global);
        }
    }

    #| build the website
    method build {
        self.write-index;
        self.collect-all-metadata;
        self.create-category-dirs;
        self.write-category-indices;
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
        my $html-file = $file-basename.subst(/\.p[l||6]$/, ".html");
        my $link = pod-link($file-basename, "$category-key/$html-file");
        my $example = Example.new(
                        title => $example-title,
                        author => $author,
                        filename => $file,
                        pod-link => $link,
                        pod-contents => $pod,
                        );

        return $example;
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

    #| write index files for all categories
    method write-category-indices {
        say "Creating category index files";
        my @headers = qw{File Title Author};
        for $!categories.categories-table.kv -> $category-key, $title {
            my $category = $!categories.category-with-key($category-key);
            my @examples = $category.examples.values;
            my @rows = @examples.map: {[.pod-link, .title, .author]};
            my $category-index-pod;

            if $category.subcategories {
                my $category-index-html = qq:to/EOT/;
                =begin Html
                <h2>Categories for $title </h2>
                <ul>
                EOT

                for $category.subcategories.categories-list -> $subcategory {
                    my $subcat-title = $subcategory.title;
                    my $subcat-key = $subcategory.key;
                    $category-index-html ~= qq:to/EOT/;
                    <li><a href="/categories/$category-key/$subcat-key.html">$subcat-title </a></li>
                    EOT
                }

                $category-index-html ~= qq:to/EOT/;
                </ul>
                =end Html
                \$=pod
                EOT
                $category-index-pod = EVAL $category-index-html;
            }
            else {
                $category-index-pod = pod-with-title($title,
                                        pod-table(@rows, headers => @headers),
                                    );
            }
            spurt $!base-html-dir ~ "/categories/$category-key.html",
                    self.p2h($category-index-pod);
            if $category.subcategories {
                my $subcategories = $category.subcategories;
                for $subcategories.categories-table.kv -> $subcategory-key, $title {
                    my $subcategory = $subcategories.category-with-key($subcategory-key);
                    my @examples = $subcategory.examples.values;
                    my @rows = @examples.map: {[.pod-link, .title, .author]};
                    my $base-dir = $!base-html-dir ~ "/categories/" ~ $category-key;
                    my $output-file = $base-dir ~ "/$subcategory-key.html";
                    spurt $output-file, self.p2h(
                        pod-with-title($title,
                            pod-table(@rows, headers => @headers),
                        ),
                    );
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
                my $example = $category.examples{$file.IO.basename};
                my $pod = format-author-heading($example);
                $pod.push: source-reference($file, $category-key);
                $pod.push: source-without-pod($file);
                my $html-file = $file.IO.basename.subst(/\.p(l|6)$/, ".html");
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
                        $pod.push: source-without-pod($file);
                        my $html-file = $file.IO.basename.subst(/\.p(l|6)$/, ".html");
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
            :header(self.header-html),
            :$footer,
            :default-title("Perl 6 Examples");
    }

    #| return the header html for the current page
    method header-html {
        my $header = slurp 'template/header.html';
        my @category-keys = $!categories.keys;
        my $menu-items = [~]
            q[<div class="menu-items dark-green">],
            @category-keys.map( -> $category {qq[
                <a class="menu-item selected darker-green"
                    href="/categories/$category.html">
                    { $category.wordcase.subst('-', ' ', :global) }
                </a>
            ]}),
            q[</div>];
        my $menu-pos = ($header ~~ /MENU/).from;
        $header.subst('MENU', :p($menu-pos), $menu-items);
    }

}

#| find all perl6 files within the given category
sub files-in-category($category, :$base-dir = "./categories") {
    dir($base-dir ~ "/$category", test => rx{ <?!after 'p5'> \.p[l||6]$ }).sort;
}

#| return the link to the POD's url
sub url($url) {
    return $url;
}

#| return the footer html for the current page
sub footer-html {
    my $footer = slurp 'template/footer.html';
    $footer.subst('DATETIME', ~DateTime.now);
}

# vim: expandtab shiftwidth=4 ft=perl6
