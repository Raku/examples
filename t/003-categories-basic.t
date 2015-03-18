use v6;

use lib 'lib';
use Test;

use Perl6::Examples;

plan 5;

subtest {
    plan 2;

    ok(Categories.new(), "A Categories object can be instantiated");

    my $categories = Categories.new(
                        categories-table => {},
                    );
    ok($categories, "Instantiation setting all attributes");
}, "Categories object instantiation";

subtest {
    plan 1;

    my $categories = Categories.new;
    my %categories-table = "key" => "value";
    $categories = Categories.new(categories-table => %categories-table);
    is($categories.categories-table, "key" => "value", "Set categories-table attr in constructor");
}, "Attribute setting";

subtest {
    plan 2;

    my %categories-table =
        "receiver" => "bob",
        "sender" => "alice",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my @categories-list = $categories.categories-list;
    is(@categories-list.elems, 2, "Returned categories list has correct length");
    ok(@categories-list[0] ~~ Category, "Categories list contains Category objects");
}, "categories-list functionality";

subtest {
    plan 1;

    my %categories-table =
        "receiver" => "bob",
        "sender" => "alice",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my %subcategories-table =
        "entangled-state" => "HH + VV",
        "initial-state" => "H + V",
    ;
    my $subcategories = Categories.new(categories-table => %subcategories-table);
    $categories.append-subcategories(to-category => "receiver", subcategories => $subcategories);
    my @categories-list = $categories.categories-list;
    ok(@categories-list[0].subcategories[0] ~~ Category, "Appended subcategory is a Category");
}

subtest {
    plan 1;

    my %categories-table =
        "receiver" => "bob",
        "sender" => "alice",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    is($categories.keys, <receiver sender>, "keys method returns expected list");
}, "keys method";

# vim: expandtab shiftwidth=4 ft=perl6
