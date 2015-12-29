use v6;

use lib 'lib';
use Test;

plan 3;

use-ok "Examples";

use Examples;
subtest {
    plan 2;

    ok(Example.new(), "An Example object can be instantiated");

    my $example = Example.new(
                    title => "",
                    author => "",
                    filename => "",
                    pod-link => "",
                    pod-contents => "",
                );
    ok($example, "Instantiation setting all attributes");
}, "Object instantiation";

subtest {
    plan 5;

    my $example = Example.new;
    $example.title = "my title";
    is($example.title, "my title", "Can set title attribute");

    $example.author = "bob";
    is($example.author, "bob", "Can set author attribute");

    $example.filename = "001-blah.pl";
    is($example.filename, "001-blah.pl", "Can set filename attribute");

    $example.pod-link = "/just/a/plain/link.html";
    is($example.pod-link, "/just/a/plain/link.html", "Can set pod-link attribute");

    $example.pod-contents = Pod::Block.new;
    ok($example.pod-contents ~~ Pod::Block, "pod-contents is a Pod::Block");

}, "Attribute setting";

# vim: expandtab shiftwidth=4 ft=perl6
