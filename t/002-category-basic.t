use v6;

use lib 'lib';
use Test;

plan 2;

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


# vim: expandtab shiftwidth=4 ft=perl6
