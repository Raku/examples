module Pod::Htmlify;

use URI::Escape;
use Pod::Convenience;
use Perl6::Examples;

sub url-munge($_) is export {
    return $_ if m{^ <[a..z]>+ '://'};
    return "/type/{uri_escape $_}" if m/^<[A..Z]>/;
    return "/routine/{uri_escape $_}" if m/^<[a..z]>|^<-alpha>*$/;
    # poor man's <identifier>
    if m/ ^ '&'( \w <[[\w'-]>* ) $/ {
        return "/routine/{uri_escape $0}";
    }
    return $_;
}

sub header-html(%categories) is export {
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

sub footer-html() is export {
    my $footer = slurp 'template/footer.html';
    $footer.subst('DATETIME', ~DateTime.now);
}

sub create-category-dirs(%categories) is export {
    for %categories.keys -> $category {
        my $dir-name = "html/categories/$category";
        mkdir $dir-name unless $dir-name.IO.d;
    }
}

sub files-in-category($category) is export {
    dir("categories/$category", test => rx{ <?!after 'p5'> \.p[l||6]$ }).sort;
}

sub collect-example-metadata(%categories) is export {
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

# vim: expandtab shiftwidth=4 ft=perl6
