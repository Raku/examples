use v6;

use Test;

plan 1;

subtest {
    plan 1;

    my $example-name = "14-09-dbi-sql.p6";
    my $expected-output = q:to/EOD/;
    [{title => Larry Wall - Keynote, APW2014 2014-10-10 , uri => https://www.youtube.com/watch?v=enlqVqit62Y} {title => Carl Mäsak - Regexes in Perl 6 - Zero to Perl 6 Training, uri => https://www.youtube.com/watch?v=oo-gA9Z9SaA}]
    EOD

    my $output = run-example($example-name);
    say "output:";
    say $output;
    is($output, $expected-output, $example-name);
    unlink "video.db"; # the script creates this file
}, "14-09-dbi-sql.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/14database-access";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
