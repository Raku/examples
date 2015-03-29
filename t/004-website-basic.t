use v6;

use lib 'lib';
use Test;
use Perl6::Examples;
use Pod::Convenience;

plan 9;

use-ok("Pod::Htmlify");

use Pod::Htmlify;

my %examples;
my $filename = "sender/bob.pl";
%examples{"sender"}{""}{$filename.IO.basename} = Example.new(
                                    title => "sender bob",
                                    author => "victor",
                                    category => "sender",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("sender bob")],
                                );
$filename = "sender/charlie.p6";
%examples{"sender"}{""}{$filename.IO.basename} = Example.new(
                                    title => "sender charlie",
                                    author => "victor",
                                    category => "sender",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("sender charlie")],
                                );
$filename = "receiver/alice.pl";
%examples{"receiver"}{""}{$filename.IO.basename} = Example.new(
                                    title => "receiver alice",
                                    author => "victor",
                                    category => "receiver",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("receiver alice")],
                                );
$filename = "receiver/eve.p6";
%examples{"receiver"}{""}{$filename.IO.basename} = Example.new(
                                    title => "receiver eve",
                                    author => "victor",
                                    category => "receiver",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("receiver eve")],
                                );

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
    my $base-html-dir = "/tmp/website-test";
    $website.base-html-dir = $base-html-dir;

    my $base-dir = $base-html-dir ~ "/categories";
    mkdir $base-dir unless $base-dir.IO.d;

    $website.create-category-dirs;

    ok(($base-dir ~ "/sender").IO.d, "category directory 'sender' created");
    ok(($base-dir ~ "/receiver").IO.d, "category directory 'receiver' created");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "create-category-dirs functionality";

subtest {
    plan 1;

    my $website = Website.new;
    my $base-dir = "/tmp/website-test";
    $website.base-html-dir = $base-dir;
    mkdir $base-dir unless $base-dir.IO.d;
    $website.write-index;

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

    my $website = Website.new(categories => $categories);
    my $base-dir = "/tmp/website-test";
    $website.base-html-dir = $base-dir;
    mkdir $base-dir unless $base-dir.IO.d;
    $website.examples-metadata = %examples;
    $website.write-category-indices;

    ok(($base-dir ~ "/sender.html").IO.e,
        "index file for 'sender' category created");
    ok(($base-dir ~ "/receiver.html").IO.e,
        "index file for 'receiver' category created");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "write-category-indices functionality";

subtest {
    plan 4;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);

    my $base-dir = "/tmp/website-test";

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    my $base-categories-dir = $base-dir ~ "/categories";
    $website.base-categories-dir = $base-categories-dir;

    mkdir $base-dir unless $base-dir.IO.d;
    mkdir $website.base-html-dir unless $website.base-html-dir.IO.d;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    # set up some fake input examples
    for <sender receiver> -> $category-dir {
        for %examples{$category-dir}{""}.values -> $example {
            my $example-dir = $website.base-categories-dir ~ "/" ~ $category-dir;
            mkdir $example-dir unless $example-dir.IO.d;
            my $example-fname = $website.base-categories-dir ~ "/" ~ $example.filename;
            my $title = $example.title;
            my $author = $example.author;
            my $example-contents = qq:to/EOF/;
            =begin pod
            =TITLE $title
            =AUTHOR $author
            =end pod
            EOF
            $example-fname.IO.spurt($example-contents);
        }
    }

    $website.create-category-dirs;
    $website.examples-metadata = %examples;
    $website.write-example-files;

    my @example-html-files = qw{
        sender/bob.html
        sender/charlie.html
        receiver/alice.html
        receiver/eve.html
    };
    for @example-html-files -> $html-file {
        ok(($base-dir ~ "/html/categories/$html-file").IO.e,
            "example file $html-file created");
    }

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "write-example-files functionality";

subtest {
    plan 3;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);

    my $base-dir = "/tmp/website-test";

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    my $base-categories-dir = $base-dir ~ "/categories";
    $website.base-categories-dir = $base-categories-dir;

    mkdir $base-dir unless $base-dir.IO.d;
    mkdir $website.base-html-dir unless $website.base-html-dir.IO.d;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    # set up some fake input examples
    for <sender receiver> -> $category-dir {
        for %examples{$category-dir}{""}.values -> $example {
            my $example-dir = $website.base-categories-dir ~ "/" ~ $category-dir;
            mkdir $example-dir unless $example-dir.IO.d;
            my $example-fname = $website.base-categories-dir ~ "/" ~ $example.filename;
            my $title = $example.title;
            my $author = $example.author;
            my $example-contents = qq:to/EOF/;
            =begin pod
            =TITLE $title
            =AUTHOR $author
            =end pod
            EOF
            $example-fname.IO.spurt($example-contents);
        }
    }

    $website.collect-example-metadata;
    my %example-metadata = $website.examples-metadata;
    ok(%example-metadata, "Non-null examples metadata structure set");

    is(%example-metadata{"receiver"}{""}{"alice.pl"}.author, "victor",
        "author name in example");
    is(%example-metadata{"sender"}{""}{"charlie.p6"}.title, "sender charlie",
        "title text in example");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "collect-example-metadata functionality";

subtest {
    plan 4;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);

    my $base-dir = "/tmp/website-test";

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    $website.base-categories-dir = $base-dir ~ "/categories";

    my $pod = pod-with-title("This is a test title");
    my $html = $website.p2h($pod);
    ok($html ~~ m/'This is a test title'/, "title text");
    ok($html ~~ m/Sender/, "category key in menu");
    ok($html ~~ m/Receiver/, "category key in menu");

    $pod = Pod::Block.new(contents => ["hello"]);
    $html = $website.p2h($pod);
    ok($html ~~ m/'Perl 6 Examples'/, "default title text");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "p2h functionality";

subtest {
    plan 7;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    $website.base-categories-dir = $base-dir ~ "/categories";

    # need to check that base-html-dir and base-categories-dir exist

    mkdir $website.base-html-dir unless $website.base-html-dir.IO.d;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    # set up some fake input examples
    for <sender receiver> -> $category-dir {
        for %examples{$category-dir}{""}.values -> $example {
            my $example-dir = $website.base-categories-dir ~ "/" ~ $category-dir;
            mkdir $example-dir unless $example-dir.IO.d;
            my $example-fname = $website.base-categories-dir ~ "/" ~ $example.filename;
            my $title = $example.title;
            my $author = $example.author;
            my $example-contents = qq:to/EOF/;
            =begin pod
            =TITLE $title
            =AUTHOR $author
            =end pod
            EOF
            $example-fname.IO.spurt($example-contents);
        }
    }

    $website.build;

    ok(($website.base-html-dir ~ "/index.html").IO.e, "index.html exists");
    ok(($website.base-html-dir ~ "/sender.html").IO.e, "sender.html exists");
    ok(($website.base-html-dir ~ "/receiver.html").IO.e, "receiver.html exists");
    ok(($website.base-html-dir ~ "/categories/sender/bob.html").IO.e,
        "sender examples html files exist");
    ok(($website.base-html-dir ~ "/categories/sender/charlie.html").IO.e,
        "sender examples html files exist");
    ok(($website.base-html-dir ~ "/categories/receiver/alice.html").IO.e,
        "receiver examples html files exist");
    ok(($website.base-html-dir ~ "/categories/receiver/eve.html").IO.e,
        "receiver examples html files exist");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "build() functionality";

#| recursively remove a directory
sub recursive-rmdir($dirname) {
    for dir($dirname) -> $path {
        $path.IO.d ?? recursive-rmdir($path) !! unlink $path;
    }
    rmdir $dirname;
}

# vim: expandtab shiftwidth=4 ft=perl6
