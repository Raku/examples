use v6;

use lib 'lib';
use Test;

plan 3;

use-ok "Examples::Categories";

use Examples::Categories;
use Examples;
use Pod::Convenience;

subtest {
    plan 2;

    ok(Category.new(), "A Category object can be instantiated");

    my $category = Category.new(
                    key => "",
                    title => "",
                    subcategories => Categories.new(),
                );
    ok($category, "Instantiation setting all attributes");
}, "Category object instantiation";

subtest {
    plan 7;

    my $category = Category.new;
    $category.key = "key";
    is($category.key, "key", "Can set key attribute");

    $category.title = "my title";
    is($category.title, "my title", "Can set title attribute");

    $category.subcategories = Categories.new(categories-table => {"subcat" => "blah"});
    ok($category.subcategories ~~ Categories, "subcategories is a Categories object");
    ok($category.subcategories, "Can set subcategories attribute");

    my %examples =
        "bob.pl" => Example.new(
            title => "sender bob",
            author => "victor",
            category => "sender",
            filename => "bob.pl",
            pod-link => pod-link("text", "url"),
            pod-contents => [pod-title("sender bob")],
        ),
        "alice.p6" => Example.new(
            title => "receiver alice",
            author => "victor",
            category => "receiver",
            filename => "alice.p6",
            pod-link => pod-link("text", "url"),
            pod-contents => [pod-title("receiver alice")],
        ),
    ;

    $category.examples = %examples;
    ok($category.examples ~~ Hash, "examples is a Hash");

    for %examples.keys -> $key {
        ok($category.examples{$key} ~~ Example,
            "examples hash contains Example objects");
    }

}, "Attribute setting";


# vim: expandtab shiftwidth=4 ft=perl6
