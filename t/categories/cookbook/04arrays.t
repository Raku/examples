use v6;

use Test;

plan 3;

subtest {
    plan 1;

    my $example-name = "04-01specifying-a-list-in-your-program.p6";
    my $expected-output = q:to/EOD/;
    beta
    alpha
    beta
    gamma
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "04-01specifying-a-list-in-your-program.p6";

subtest {
    plan 1;

    my $example-name = "04-02printing-a-list-with-commas.p6";
    my $expected-output = q:to/EOD/;
    foo
    this and that
    alpha, beta and gamma
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "04-02printing-a-list-with-commas.p6";

subtest {
    plan 1;

    my $example-name = "04-05iterating-over-an-array.p6";
    my $expected-output = q:to/EOD/;
    94
    13
    97
    95
    12
    13
    74
    10
    47
    4
    62
    47
    75
    36
    25
    35
    0
    71
    56
    50
    72
    39
    30
    93
    94
    13
    97
    95
    12
    13
    74
    10
    47
    4
    62
    47
    75
    36
    25
    35
    0
    71
    56
    50
    72
    39
    30
    93
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "04-05iterating-over-an-array.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/04arrays";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
