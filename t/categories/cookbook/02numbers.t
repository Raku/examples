use v6;

use Test;

plan 3;

subtest {
    plan 1;

    my $example-name = "02-01valid-number.p6";
    my $expected-output = q:to/EOD/;
    12 is a Integer
    14.12 is a Rational
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "02-01valid-number.p6";

subtest {
    plan 1;

    my $example-name = "02-14complex-number.p6";
    my $expected-output = q:to/EOD/;
    16+4i
    2+1i
    5
    3
    4
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "02-14complex-number.p6";

subtest {
    plan 1;

    my $example-name = "02-15convert-bases.p6";
    my $expected-output = q:to/EOD/;
    3735928559
    493
    755
    4277009102
    FEEDFACE
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "02-15convert-bases.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/02numbers";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
