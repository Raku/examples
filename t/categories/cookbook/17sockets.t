use v6;

use Test;

plan 1;

subtest {
    plan 1;

    my $example-name = "17-01tcp_client.p6";
    my $expected-output = rx{:i 'HTTP/1.1' 200|302};

    my $output = run-example($example-name);
    like($output, $expected-output, $example-name);
}, "17-01tcp_client.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/17sockets";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
