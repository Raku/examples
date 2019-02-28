use v6;

use Test;

plan 1;

subtest {
    plan 1;

    my $example-name = "07-01opening_file.p6";
    my $expected-output = q:to/EOD/;
    ok last
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
    unlink "test_file";  # the script generates this file
}, "07-01opening_file.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/07file-access";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
