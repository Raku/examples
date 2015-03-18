module Pod::Htmlify;

use URI::Escape;

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

# vim: expandtab shiftwidth=4 ft=perl6
