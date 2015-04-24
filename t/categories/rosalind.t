use v6;

use Test;

plan 5;

subtest {
    plan 1;

    my $problem = "afrq";
    my @authors = <grondilu>;
    my $expected-output = "0.532 0.75 0.914";

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }

}, "afrq";

subtest {
    plan 1;

    my $problem = "aspc";
    my @authors = <grondilu>;
    my $expected-output = 42;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }

}, "aspc";

subtest {
    plan 1;

    my $problem = "cons";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    ATGCAACT
    A: 5 1 0 0 5 5 0 0
    C: 0 0 1 4 2 0 6 1
    G: 1 1 6 3 0 1 0 0
    T: 1 5 0 0 0 1 1 6
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "cons";

subtest {
    plan 1;

    my $problem = "conv";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    3
    85.03163
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "conv";

subtest {
    plan 1;

    my $problem = "cstr";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    10110
    10100
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "cstr";

#| check examples provided by the given authors
sub check-example-solutions($problem, $expected-output, @authors) {
    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }
}

#| run the given example script
sub run-example($name) {
    my $base-dir = "categories/rosalind";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
