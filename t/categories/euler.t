use v6;

use Test;

plan 4;

subtest {
    plan 5;

    my $problem = "prob001";
    my @authors = <cspencer eric256 grondilu hexmode unobe>;
    my $expected-output = 233168;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }

}, "prob001";

subtest {
    plan 3;

    my $problem = "prob002";
    my @authors = <eric256 gerdr hexmode>;
    my $expected-output = 4613732;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob002";

subtest {
    plan 4;

    my $problem = "prob003";
    my @authors = <eric256 gerdr hexmode lanny>;
    my $expected-output = 6857;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob003";

subtest {
    plan 1;

    my $problem = "prob004";
    my @authors = <unobe>;
    my $expected-output = 906609;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob004";

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
    my $base-dir = "categories/euler";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
