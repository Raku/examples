use v6;

use lib 'lib';
use Test;
use Perl6::Examples;
use Pod::Convenience;

plan 5;

use-ok("Pod::Htmlify");

use Pod::Htmlify;

subtest {
    plan 4;

    ok(Website.new, "A website object can be instantiated");

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my $website = Website.new(categories => $categories);
    ok($website.categories, "categories initialised to a value");
    is($website.categories.keys.elems, 2, "number of keys in categories");

    is($website.base-html-dir, "html", "base html directory");
}, "Website object instantiation";

subtest {
    plan 2;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my $website = Website.new(categories => $categories);
    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;
    $website.create-category-dirs(base-dir => $base-dir);

    ok(($base-dir ~ "/sender").IO.d, "category directory 'sender' created");
    ok(($base-dir ~ "/receiver").IO.d, "category directory 'receiver' created");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "create-category-dirs functionality";

subtest {
    plan 1;

    my $website = Website.new;
    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;
    $website.write-index(base-dir => $base-dir);

    ok(($base-dir ~ "/index.html").IO.f, "index file created");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "write-index functionality";

subtest {
    plan 2;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);

    my %examples;
    %examples{"sender"}{""}{"bob"} = Example.new(
                                        title => "sender bob",
                                        author => "victor",
                                        category => "sender",
                                        filename => "bob",
                                        pod-link => "",
                                        pod-contents => pod-title("sender bob"),
                                    );
    %examples{"sender"}{""}{"charlie"} = Example.new(
                                        title => "sender charlie",
                                        author => "victor",
                                        category => "sender",
                                        filename => "charlie",
                                        pod-link => "",
                                        pod-contents => pod-title("sender charlie"),
                                    );
    %examples{"receiver"}{""}{"alice"} = Example.new(
                                        title => "receiver alice",
                                        author => "victor",
                                        category => "reciever",
                                        filename => "alice",
                                        pod-link => "",
                                        pod-contents => pod-title("receiver alice"),
                                    );
    %examples{"receiver"}{""}{"eve"} = Example.new(
                                        title => "receiver eve",
                                        author => "victor",
                                        category => "reciever",
                                        filename => "eve",
                                        pod-link => "",
                                        pod-contents => pod-title("receiver eve"),
                                    );

    my $website = Website.new(categories => $categories);
    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;
    $website.create-category-dirs(base-dir => $base-dir);
    $website.write-category-indices(%examples, base-dir => $base-dir);

    ok(($base-dir ~ "/sender.html").IO.f,
        "index file for 'sender' category created");
    ok(($base-dir ~ "/receiver.html").IO.f,
        "index file for 'receiver' category created");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "write-category-indices functionality";

#| recursively remove a directory
sub recursive-rmdir($dirname) {
    for dir($dirname) -> $path {
        $path.IO.d ?? recursive-rmdir($path) !! unlink $path;
    }
    rmdir $dirname;
}

# vim: expandtab shiftwidth=4 ft=perl6
