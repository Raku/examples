use v6;

use Test;

plan 4;

my $skip = True;

subtest {
    plan 1;

    my $problem = "event001-eric256.pl";
    my $expected-output = q:to/EOD/;
    READING
    EOD

    my $output = run-example($problem);
    is($output.chomp, $expected-output.chomp, $problem);
}, "event001-eric256";

subtest {
    plan 1;

    my $problem = "event002-eric256.pl";
    my $expected-output = q:to/EOD/;
    Gold: Guido Chuffart: 94.2
    Silver: Chase Carpenter: 91.8
    Bronze: Cecilia Cornejo: 91.6
    EOD

    my $output = run-example($problem);
    is($output.chomp, $expected-output.chomp, $problem);
}, "event002-eric256";

subtest {
    plan 1;

    my $problem = "event005-eric256.pl";
    my $expected-output = q:to/EOD/;
    No uppercase letters in password.
    Four consecutive lowercase letters in password.
    Duplicate letters in password.

    A password score of 10 indicates a moderately-strong password.
    EOD

    my $output = run-example($problem, script-args => "--pw=rhubarb33!");
    is($output.chomp, $expected-output.chomp, $problem);
}, "event005-eric256";

subtest {
    plan 1;

    my $problem = "event010-dwhipp.p6";
    my $expected-output = q:to/EOD/;
    DEALER:
    three of diamonds

    PLAYER:
    five of diamonds
    ten of diamonds
    current value is 15
    hit (h) or stay (s)
    hit
    two of diamonds
    current value is 17
    hit (h) or stay (s)
    stay

    DEALER:
    three of diamonds
    seven of diamonds
    dealer value: 10
    jack of spades
    dealer value: 20
    you lose!
    EOD

    my $output = run-example($problem, script-args => "--computer-player");
    is($output.chomp, $expected-output.chomp, $problem);
}, "event010-dwhipp.p6";


#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/wsg/advanced-2008";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
