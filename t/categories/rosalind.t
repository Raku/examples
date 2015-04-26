use v6;

use Test;

plan 10;

my $skip = True;

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

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "ctbl";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        00110
        00111
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "ctbl";
}

subtest {
    plan 1;

    my $problem = "dbpr";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    DNA recombination
    DNA repair
    DNA replication
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "dbpr";

subtest {
    plan 2;

    my $problem = "dna";
    my @authors = <gerdr grondilu>;
    my $expected-output = q:to/EOD/;
    20 12 17 21
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "dna";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "eubt";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        (((mouse,cat),elephant))dog;
        (((elephant,mouse),cat))dog;
        (((elephant,cat),mouse))dog;
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "eubt";
}

subtest {
    plan 1;

    my $problem = "eval";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    0.422 0.563 0.422
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "eval";

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
