use v6;

use lib 'lib';
use Test;
use Examples;
use Examples::Categories;
use Pod::Convenience;

plan 12;

use-ok("Pod::Htmlify");

use Pod::Htmlify;

my %examples;
my $filename = "receiver/bob.pl";
%examples{"receiver"}{$filename.IO.basename} = Example.new(
                                    title => "receiver bob",
                                    author => "victor",
                                    category => "receiver",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("receiver bob")],
                                );
$filename = "receiver/charlie.p6";
%examples{"receiver"}{$filename.IO.basename} = Example.new(
                                    title => "receiver charlie",
                                    author => "victor",
                                    category => "receiver",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("receiver charlie")],
                                );
$filename = "sender/alice.pl";
%examples{"sender"}{$filename.IO.basename} = Example.new(
                                    title => "sender alice",
                                    author => "victor",
                                    category => "sender",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("sender alice")],
                                );
$filename = "sender/eve.p6";
%examples{"sender"}{$filename.IO.basename} = Example.new(
                                    title => "sender eve",
                                    author => "victor",
                                    category => "sender",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("sender eve")],
                                );

$filename = "quantum/victor.p6";
%examples{"verifier"}{$filename.IO.basename} = Example.new(
                                    title => "quantum verifier victor",
                                    author => "victor",
                                    category => "verifier",
                                    filename => $filename,
                                    pod-link => pod-link("text", "url"),
                                    pod-contents => [pod-title("quantum verifier victor")],
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

    my $website = Website.new;
    is $website.syntax-highlighting, True, "syntax highlighting on by default";
    $website.syntax-highlighting = False;
    is $website.syntax-highlighting, False,
        "syntax highlighting turned off successfully";
}, "--no-highlight option";

subtest {
    plan 1;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my $website = Website.new(categories => $categories);

    my %expected-tabs =
        "/categories/sender.html" => "Sender",
        "/categories/receiver.html" => "Receiver",
    ;
    is($website.menu-tabs, %expected-tabs,
        "menu tabs set automatically from category keys");
}, "menu-tabs functionality";

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
    plan 4;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
        "verifier" => "victor",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my %subcategories-table =
        "quantum" => "victor",
    ;
    my $quantum-subcategories = Categories.new(categories-table => %subcategories-table);
    $categories.append-subcategories(
        to-category => "verifier",
        subcategories => $quantum-subcategories
    );

    my $website = Website.new(categories => $categories);
    my $base-dir = "/tmp/website-test";
    $website.base-html-dir = $base-dir;
    mkdir $base-dir unless $base-dir.IO.d;

    my $base-categories-dir = $base-dir ~ "/categories";
    $website.base-categories-dir = $base-categories-dir;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    create-fake-examples($website);

    $website.collect-all-metadata;
    $website.create-category-dirs;
    $website.write-category-indices;

    ok(($base-dir ~ "/categories/sender.html").IO.e,
        "index file for 'sender' category created");
    ok(($base-dir ~ "/categories/receiver.html").IO.e,
        "index file for 'receiver' category created");
    ok(($base-dir ~ "/categories/verifier.html").IO.e,
        "index file for 'verifier' category created");
    ok(($base-dir ~ "/categories/verifier/quantum.html").IO.e,
        "index file for 'quantum' subcategory of 'verifier' category created");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "write-category-indices functionality";

subtest {
    plan 5;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
        "verifier" => "victor",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my %subcategories-table =
        "quantum" => "victor",
    ;
    my $quantum-subcategories = Categories.new(categories-table => %subcategories-table);
    $categories.append-subcategories(
        to-category => "verifier",
        subcategories => $quantum-subcategories
    );

    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    mkdir $website.base-html-dir unless $website.base-html-dir.IO.d;

    my $base-categories-dir = $base-dir ~ "/categories";
    $website.base-categories-dir = $base-categories-dir;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    create-fake-examples($website);

    $website.syntax-highlighting = False;
    $website.create-category-dirs;
    $website.collect-all-metadata;
    $website.write-example-files;

    my @example-html-files = qw{
        receiver/bob.html
        receiver/charlie.html
        sender/alice.html
        sender/eve.html
        verifier/quantum/victor.html
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
        "sender" => "bob",
        "receiver" => "alice",
        "verifier" => "victor",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my %subcategories-table =
        "quantum" => "victor",
    ;
    my $quantum-subcategories = Categories.new(categories-table => %subcategories-table);
    $categories.append-subcategories(
        to-category => "verifier",
        subcategories => $quantum-subcategories
    );

    my $base-dir = "/tmp/website-test";

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    my $base-categories-dir = $base-dir ~ "/categories";
    $website.base-categories-dir = $base-categories-dir;

    mkdir $base-dir unless $base-dir.IO.d;
    mkdir $website.base-html-dir unless $website.base-html-dir.IO.d;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    create-fake-examples($website);

    $website.collect-all-metadata;

    my $sender-category = $website.categories.category-with-key("sender");
    my $alice-example = $sender-category.examples{"alice.pl"};
    is($alice-example.author, "victor", "author name in example");

    my $receiver-category = $website.categories.category-with-key("receiver");
    my $charlie-example = $receiver-category.examples{"charlie.p6"};
    is($charlie-example.title, "receiver charlie", "title text in example");

    my $verifier-category = $website.categories.category-with-key("verifier");
    my $verifier-subcategory = $verifier-category.subcategories.category-with-key("quantum");
    my $victor-example = $verifier-subcategory.examples{"victor.p6"};
    is($victor-example.title, "quantum verifier victor",
        "title text in subcategory example");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "collect-all-metadata functionality";

subtest {
    plan 8;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my $website = Website.new(categories => $categories);

    my $header-html = $website.header-html;
    ok($header-html ~~ m/'sender.html'/, "category key link in menu tab");
    ok($header-html ~~ m/'receiver.html'/, "category key link in menu tab");
    ok($header-html ~~ m/Sender/, "wordcase category key in menu tab");
    ok($header-html ~~ m/Receiver/, "wordcase category key in menu tab");

    # menu items set explicitly
    $website.menu-tabs =
        "verifier.html" => "Verifier: Victor",
        "eavesdropper.html" => "Eavesdropper: Eve",
    ;

    $header-html = $website.header-html;
    ok($header-html ~~ m/'verifier.html'/, "explicitly set menu tab link");
    ok($header-html ~~ m/'eavesdropper.html'/, "explicitly set menu tab link");
    ok($header-html ~~ m/'Verifier: Victor'/, "explicitly set menu tab text`");
    ok($header-html ~~ m/'Eavesdropper: Eve'/, "explicitly set menu tab text`");

}, "header-html functionality";


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
    plan 9;

    my %categories-table =
        "sender" => "alice",
        "receiver" => "bob",
        "verifier" => "victor",
    ;
    my $categories = Categories.new(categories-table => %categories-table);
    my %subcategories-table =
        "quantum" => "quantum victor",
    ;
    my $quantum-subcategories = Categories.new(categories-table => %subcategories-table);
    $categories.append-subcategories(
        to-category => "verifier",
        subcategories => $quantum-subcategories
    );

    my $base-dir = "/tmp/website-test";
    mkdir $base-dir unless $base-dir.IO.d;

    my $website = Website.new(categories => $categories);
    $website.base-html-dir = $base-dir ~ "/html";
    $website.base-categories-dir = $base-dir ~ "/categories";

    mkdir $website.base-html-dir unless $website.base-html-dir.IO.d;
    mkdir $website.base-categories-dir unless $website.base-categories-dir.IO.d;

    create-fake-examples($website);

    $website.syntax-highlighting = False;
    $website.build;

    ok(($website.base-html-dir ~ "/index.html").IO.e, "index.html exists");
    ok(($website.base-html-dir ~ "/categories/sender.html").IO.e, "sender.html exists");
    ok(($website.base-html-dir ~ "/categories/receiver.html").IO.e, "receiver.html exists");
    ok(($website.base-html-dir ~ "/categories/receiver/bob.html").IO.e,
        "receiver examples html files exist");
    ok(($website.base-html-dir ~ "/categories/receiver/charlie.html").IO.e,
        "receiver examples html files exist");
    ok(($website.base-html-dir ~ "/categories/sender/alice.html").IO.e,
        "sender examples html files exist");
    ok(($website.base-html-dir ~ "/categories/sender/eve.html").IO.e,
        "sender examples html files exist");
    ok(($website.base-html-dir ~ "/categories/verifier.html").IO.e,
        "verifier examples summary html file exists");
    my $verifier-summary = slurp $website.base-html-dir ~ "/categories/verifier.html";
    ok($verifier-summary ~~ /"quantum victor"/, "verifier contents");

    recursive-rmdir($base-dir) if $base-dir.IO.d;
}, "build() functionality";

#| recursively remove a directory
sub recursive-rmdir($dirname) {
    for dir($dirname) -> $path {
        $path.IO.d ?? recursive-rmdir($path) !! unlink $path;
    }
    rmdir $dirname;
}

#| set up some fake input examples
sub create-fake-examples($website) {
    for <sender receiver verifier> -> $category-dir {
        for %examples{$category-dir}.values -> $example {
            my $example-dir = $website.base-categories-dir ~ "/" ~ $category-dir;
            mkdir $example-dir unless $example-dir.IO.d;
            if $category-dir eq "verifier" {
                my $subcat-dir = $example-dir ~ "/" ~ "quantum";
                mkdir $subcat-dir unless $subcat-dir.IO.d;
                write-fake-example($example, $example-dir);
            }
            else {
                write-fake-example($example, $website.base-categories-dir);
            }
        }
    }
}

#| write the actual fake example text to file
sub write-fake-example($example, $base-dir) {
    my $example-fname = $base-dir ~ "/" ~ $example.filename;
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

# vim: expandtab shiftwidth=4 ft=perl6
