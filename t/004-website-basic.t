use v6;

use lib 'lib';
use Test;
use Perl6::Examples;

plan 3;

use-ok("Pod::Htmlify");

use Pod::Htmlify;

ok(Website.new, "A website object can be instantiated");

subtest {
    plan 2;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my $website = Website.new;
    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;
    $website.create-category-dirs($categories, base-dir => $base-dir);

    ok(($base-dir ~ "/sender").IO.d, "category directory 'sender' created");
    ok(($base-dir ~ "/receiver").IO.d, "category directory 'receiver' created");

    rmdir $base-dir if $base-dir.IO.d;
}, "create-category-dirs functionality";

# vim: expandtab shiftwidth=4 ft=perl6
