unit module Pod::Htmlify;

use URI::Escape;
use HTML::Escape;
use Pod::To::HTML;
use Pod::Convenience;
use Examples;
use MONKEY-SEE-NO-EVAL;  # until we have better serialisation

class Website is export {
    has $.categories is rw;
    has $.base-html-dir is rw = "html";
    has $.base-categories-dir is rw = "categories";
    has $.syntax-highlighting is rw = True;
    has %.menu-tabs;

    submethod BUILD(:$categories) {
        $!categories = $categories;
        for $categories.keys -> $category-key {
            %!menu-tabs{"/categories/" ~ $category-key ~ ".html"} =
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
            self.collect-category-metadata($category, $!base-categories-dir);
            if $category.subcategories {
                for $category.subcategories.categories-list <-> $subcategory {
                    my $base-dir = $!base-categories-dir ~ "/" ~ $category.key;
                    self.collect-category-metadata($subcategory, $base-dir);
                }
            }
        }
    }

    #| collect metadata for a given category
    method collect-category-metadata($category, $category-dir) {
        my $category-key = $category.key;
        my @files = files-in-category($category-key, base-dir => $category-dir);
        for @files -> $file {
            my $example = self.collect-example-metadata($file, $category-key);
            $category.examples{$file.basename} = $example;
        }
    }

    #| collect metadata for a given example
    method collect-example-metadata($file, $category-key) {
        say "Collecting metadata from $file";
        my $perl-pod = qqx{$*EXECUTABLE -Ilib --doc=Perl $file};
        my $file-basename = $file.basename;
        my $pod = (EVAL $perl-pod) || [pod-with-title($file-basename)];
        my $example-title = pod-title-contents($pod, $file-basename);
        my $author = pod-author-contents($pod, $file-basename);
        my $html-file = $file-basename.subst(/\.p[l||6||m]$/, ".html");
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
        for $!categories.categories-table.sort(*.key)>>.kv -> ($category-key, $title) {
            my $category = $!categories.category-with-key($category-key);
            my @examples = $category.examples.values.sort({ $^a.filename cmp $^b.filename });
            my @rows = @examples.map: {[.pod-link, .title, .author]};
            my $category-index-pod;

            if $category.subcategories {
                my $category-index-html = qq:to/EOT/;
                =begin Html
                <h2>Categories for $title </h2>
                <ul>
                EOT

                for $category.subcategories.categories-list.sort(*.key) -> $subcategory {
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
                    my @examples = $subcategory.examples.values.sort(*.filename);
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
            my $html-dir = $!base-html-dir ~ "/categories/$category-key/";
            self.write-example-html($category, $!base-categories-dir, $html-dir);
            if $category.subcategories {
                for $category.subcategories.categories-list -> $subcategory {
                    my $subcategory-key = $subcategory.key;
                    say "Creating example files for subcategory: $subcategory-key";
                    my $base-dir = $!base-categories-dir ~ "/" ~ $category-key;
                    my $html-dir = $!base-html-dir ~ "/categories/$category-key/$subcategory-key/";
                    self.write-example-html($subcategory, $base-dir, $html-dir);
                }
            }
        }
    }

    #| write example html to file
    method write-example-html($category, $category-dir, $html-dir) {
        my @files = files-in-category($category.key, base-dir => $category-dir);
        for @files -> $file {
            next unless $file.IO.e;
            my $example = $category.examples{$file.IO.basename};
            my $pod = format-author-heading($example);
            $pod.push: source-reference($file, $category.key, $category-dir);
            $pod.push: source-without-pod($file);
            my $html-file = $file.IO.basename.subst(/\.p(l|6|m)$/, ".html");
            $html-file = $html-dir ~ $html-file;
            spurt $html-file, self.p2h($pod);
        }
    }

    #| convert the POD into html
    method p2h($pod) {
        my $vim-colour = $.syntax-highlighting && (try 
            require Text::VimColour) !=== Nil;

        my $head = slurp 'template/head.html';
        my $footer = footer-html;
        my %*POD2HTML-CALLBACKS = code => sub (:$node, :&default) {
            if $vim-colour {
                try {
                    my $v = ::('Text::VimColour').new(
                        lang => 'perl6',
                        code => $node.contents.join
                    );
                    return $v.html;
                    CATCH {
                        default {
                            return "<!-- Error while syntax highlighting this piece of code: $_.message() -->\n" ~
                                "<pre>" ~ $node.contents.join.&escape-html ~ "</pre>";
                        }
                    }
                }
            }
            else {
                return "<pre>" ~ $node.contents.join.&escape-html ~ "</pre>";
            }
        };
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
            %!menu-tabs.keys.sort.map( -> $menu-tab-link {qq[
                <a class="menu-item selected darker-green"
                    href="$menu-tab-link">
                    { %!menu-tabs{$menu-tab-link} }
                </a>
            ]}),
            q[</div>];
        my $menu-pos = ($header ~~ /MENU/).from;
        $header.subst('MENU', :p($menu-pos), $menu-items);
    }

}

#| find all perl6 files within the given category
sub files-in-category($category, :$base-dir = "./categories") {
    dir($base-dir ~ "/$category", test => rx{ <?!after 'p5'> \.p[l||6||m]$ }).sort;
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
