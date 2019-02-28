use v6;

use Test;

plan 7;

subtest {
    plan 1;

    my $example-name = "03-01-todays-date.p6";
    my $expected-output = rx/\d ** 4 \s+ \d ** 1..2 \s+ \d ** 1..2/;

    my $output = run-example($example-name);
    like($output, $expected-output, $example-name);
}, "03-01-todays-date.p6";

subtest {
    plan 1;

    my $example-name = "03-02-datetime-to-epoch.p6";
    my $expected-output = 361584000;

    my $output = run-example($example-name);
    is($output.chomp, $expected-output, $example-name);
}, "03-02-datetime-to-epoch.p6";

subtest {
    plan 1;

    my $example-name = "03-03-epoch-to-datetime.p6";
    my $expected-output = q:to/EOD/;
    2014-12-05T15:27:14Z
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "03-03-epoch-to-datetime.p6";

subtest {
    plan 1;

    my $example-name = "03-04-date-add-sub.p6";
    my $expected-output = q:to/EOD/;
    1981-05-20
    1981-07-01T20:00:00Z
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "03-04-date-add-sub.p6";

subtest {
    plan 1;

    my $example-name = "03-05-sub-two-dates.p6";
    my $expected-output = 17655;

    my $output = run-example($example-name);
    is($output.chomp, $expected-output, $example-name);
}, "03-05-sub-two-dates.p6";

subtest {
    plan 1;

    my $example-name = "03-06-day-to-num-wmy.p6";
    my $expected-output = q:to/EOD/;
    31 8 216
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "03-06-day-to-num-wmy.p6";

subtest {
    plan 1;

    my $example-name = "03-09-hires-times.p6";
    my $expected-output = 2;

    my $output = run-example($example-name);
    my $diff = abs($expected-output - $output.chomp);
    ok($diff < 1e-1, $example-name) or die dd $diff;
}, "03-09-hires-times.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/03dates-and-times";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
