use v6;

use lib 'lib';
use Test;

plan 3;

use-ok "Perl6::Examples";

use Perl6::Examples;

subtest {
    plan 2;

    ok(Category.new(), "A Category object can be instantiated");

    my $category = Category.new(
                    key => "",
                    title => "",
                    subcategories => ["", ""],
                );
    ok($category, "Instantiation setting all attributes");
}, "Category object instantiation";

subtest {
    plan 4;

    my $category = Category.new;
    $category.key = "key";
    is($category.key, "key", "Can set key attribute");

    $category.title = "my title";
    is($category.title, "my title", "Can set title attribute");

    $category.subcategories = ("bob", "alice");
    ok($category.subcategories ~~ Array, "subcategories is an Array");
    is($category.subcategories, ("bob", "alice"), "Can set subcategories attribute");

}, "Attribute setting";


# vim: expandtab shiftwidth=4 ft=perl6
