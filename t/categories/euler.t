use v6;

use Test;

plan 9;

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

subtest {
    plan 2;

    my $problem = "prob005";
    my @authors = <unobe xfix>;
    my $expected-output = 232792560;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob005";

subtest {
    plan 1;

    my $problem = "prob006";
    my @authors = <polettix>;
    my $expected-output = 25164150;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob006";

subtest {
    plan 1;

    my $problem = "prob007";
    my @authors = <polettix>;
    my $expected-output = 104743;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob007";

subtest {
    plan 2;

    my $problem = "prob008";
    my @authors = <duff duff2>;
    my $expected-output = 40824;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob008";

subtest {
    plan 3;

    my $problem = "prob009";
    my @authors = <gerdr-feeds gerdr polettix>;
    my $expected-output = 31875000;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob009";

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
