use v6;

use Test;

plan 1;

subtest {
    plan 1;

    my $example-name = "10-01arguments.pl";
    my $expected-output = q:to/EOD/;
    old-fashioned
    some parameter
    some parameter
    some parameter
    some parameter
    array
    elements
    are => pairs
    hash => elements
    this
    Told you it was optional!
    this
    that
    123
    123
    Transporting to Magrathea:
        Arthur
        Ford
        Ovid
    You gave me the integer: 3
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "10-01arguments.pl";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/10subroutines";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
