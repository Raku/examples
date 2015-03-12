use v6;

use lib 'lib';
use Test;

plan 3;

use-ok "Perl6::Example";

use Perl6::Example;
subtest {
    plan 2;

    ok(Example.new(), "An Example object can be instantiated");

    my $example = Example.new(
                    title => "",
                    author => "",
                    category => "",
                    subcategory => "",
                    filename => "",
                    pod-link => "",
                );
    ok($example, "Instantiation setting all attributes");
}, "Object instantiation";

subtest {
    plan 6;

    my $example = Example.new;
    $example.title = "my title";
    is($example.title, "my title", "Can set title attribute");

    $example.author = "bob";
    is($example.author, "bob", "Can set author attribute");

    $example.category = "Cookbook";
    is($example.category, "Cookbook", "Can set category attribute");

    $example.subcategory = "Strings";
    is($example.subcategory, "Strings", "Can set subcategory attribute");

    $example.filename = "001-blah.pl";
    is($example.filename, "001-blah.pl", "Can set filename attribute");

    $example.pod-link = "/just/a/plain/link.html";
    is($example.pod-link, "/just/a/plain/link.html", "Can set pod-link attribute");

}, "Attribute setting";

# vim: expandtab shiftwidth=4 ft=perl6
