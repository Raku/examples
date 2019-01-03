use v6;

use lib 'lib';
use Test;

use Examples::Categories;

plan 6;

subtest {
    plan 2;

    ok(Categories.new(), "A Categories object can be instantiated");

    my Categories $categories .= new(
                        categories-table => {},
                    );
    ok($categories, "Instantiation setting all attributes");
}, "Categories object instantiation";

subtest {
    plan 1;

    my Categories $categories .= new;
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
    my Categories $categories .= new(categories-table => %categories-table);
    my @categories-list = $categories.categories-list;
    is(@categories-list.elems, 2, "Returned categories list has correct length");
    ok(@categories-list[0] ~~ Category, "Categories list contains Category objects");
}, "categories-list functionality";

subtest {
    plan 5;

    my %categories-table =
        "receiver" => "bob",
        "sender" => "alice",
    ;
    my Categories $categories .= new(categories-table => %categories-table);
    my %subcategories-table =
        "entangled-state" => "HH + VV",
        "initial-state" => "H + V",
    ;
    my $subcategories = Categories.new(categories-table => %subcategories-table);
    $categories.append-subcategories(
        to-category => "receiver",
        subcategories => $subcategories);
    my @categories-list = $categories.categories-list;
    ok(@categories-list[0].subcategories ~~ Categories,
        "Appended subcategories are a Categories object");
    my @subcategories-list = @categories-list[0].subcategories.categories-list;
    ok(@subcategories-list[0] ~~ Category,
        "Appended subcategory is a Category object");
    is(@subcategories-list.elems, 2, "Number of appended subcategories");
    ok(@subcategories-list[0].key ~~ ("entangled-state", "initial-state").any,
        "Appended subcategory contains expected data");
    ok(@subcategories-list[1].key ~~ ("entangled-state", "initial-state").any,
        "Appended subcategory contains expected data");
}, "append-subcategories functionality";

subtest {
    plan 1;

    my %categories-table =
        "receiver" => "bob",
        "sender" => "alice",
    ;
    my Categories $categories .= new(categories-table => %categories-table);
    is($categories.keys.sort, <receiver sender>, "keys method returns expected list");
}, "keys method";

subtest {
    plan 2;

    my %categories-table =
        "receiver" => "bob",
        "sender" => "alice",
    ;
    my Categories $categories .= new(categories-table => %categories-table);
    my $expected-category = Category.new(
                                key => "receiver",
                                title => "bob",
                            );
    is($categories.category-with-key("receiver").key, $expected-category.key,
        "expected Category object returned");
    is($categories.category-with-key("receiver").title, $expected-category.title,
        "expected Category object returned");
}, "category-with-key method";

# vim: expandtab shiftwidth=4 ft=perl6
