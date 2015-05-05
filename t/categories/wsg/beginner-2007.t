use v6;

use Test;

plan 1;

my $skip = True;

subtest {
    plan 1;

    my $problem = "event003-eric256.pl";
    my $expected-output = q:to/EOD/;
    MONDAY
    TUESDAY
    WEDNESDAY
    THURSDAY
    FRIDAY
    EOD

    my $output = run-example($problem);
    is($output.chomp, $expected-output.chomp, $problem);
}, "event003-eric256";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/wsg/beginner-2007";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
