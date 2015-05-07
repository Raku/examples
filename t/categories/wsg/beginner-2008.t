use v6;

use Test;

plan 4;

my $skip = True;

subtest {
    plan 3;

    my $problem = "event001";
    my @authors = <eric256 j1n3l0 unobe>;
    my $expected-output = q:to/EOD/;
    Total: 3
    EOD

    check-example-solutions($problem, $expected-output.chomp, @authors)
}, "event001";

subtest {
    plan 1;

    my $problem = "event003";
    my @authors = <unobe>;
    my $expected-output = q:to/EOD/;
    Dulce et decorum est...
    "There have always been literate ignoramuses who have read too widely and not
    3
    "There is no such thing on earth as an uninteresting subject; the only
    T
    EOD

    my $name = $problem ~ '-' ~ @authors[0] ~ '.pl';
    run-example($name);
    my $output-file = 'categories/wsg/beginner-2008/newfile.txt';
    my $output = $output-file.IO.slurp;
    is($output, $expected-output, $name);
}, "event003";

subtest {
    plan 2;

    my $problem = "event006";
    my @authors = <eric256 j1n3l0>;
    my $expected-output = q:to/EOD/;
    Espresso: 13
    Latte: 22
    Cappuccino: 18
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.split(/\n/).sort, $expected-output.split(/\n/).sort, $name);
    }
}, "event006";

subtest {
    plan 1;

    my $problem = "event010";
    my @authors = <eric256>;
    my $expected-output = q:to/EOD/;
    checking 2
    checking 5
    checking 7
    checking /
    checking 8
    checking 1
    checking X
    checking 9
    checking /
    checking 5
    checking 3
    checking 7
    checking 0
    checking 4
    checking 5
    checking X
    checking 2
    checking 0
    66
    EOD

    check-example-solutions($problem, $expected-output.chomp, @authors)
}, "event010";

#| check examples provided by the given authors
sub check-example-solutions($problem, $expected-output, @authors) {
    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }
}

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/wsg/beginner-2008";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
