use v6;

use lib 'lib';
use Test;

use Perl6::Examples;

plan 3;

subtest {
    plan 2;

    ok(Categories.new(), "A Categories object can be instantiated");

    my $categories = Categories.new(
                        categories-table => {},
                    );
    ok($categories, "Instantiation setting all attributes");
}, "Categories object instantiation";

subtest {
    plan 2;

    my $categories = Categories.new;
    my %categories-table = "key" => "value";
    $categories.categories-table = %categories-table;
    is($categories.categories-table, "key" => "value", "Can set categories-table attribute");

    $categories = Categories.new(categories-table => %categories-table);
    is($categories.categories-table, "key" => "value", "Set categories-table attr in constructor");
}, "Attribute setting";

subtest {
    plan 2;

    my %categories-table =
        "bob" => "receiver",
        "alice" => "sender",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my @categories-list = $categories.categories-list;
    is(@categories-list.elems, 2, "Returned categories list has correct length");
    ok(@categories-list[0] ~~ Category, "Categories list contains Category objects");
}, "categories-list functionality";

# vim: expandtab shiftwidth=4 ft=perl6
