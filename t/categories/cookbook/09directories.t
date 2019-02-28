use v6;

use Test;
use File::Temp;

plan 5;

my $skip = True;

subtest {
    plan 1;

    my $example-name = "09-01-get-set-filetime.p6";
    my $expected-output = rx/':dt($('['\d+\.0'||'<' \d+\/\d+ '>']', '['Bool::False'||'0']'))'/;

    my $output = run-example($example-name);
    like($output, $expected-output, $example-name);
}, "09-01-get-set-filetime.p6";

subtest {
    plan 1;

    my $example-name = "09-05-all-files-dir.p6";
    my $tempdir = tempdir;
    my @filenames = <alice bob charlie eve>;
    my $expected-output;
    for @filenames -> $file {
        my $path = $*SPEC.catdir($tempdir, $file);
        $expected-output ~= $path.IO.Str ~ "\n";
        my $fh = open $path, :w or die "$!";
        $fh.close;
    }

    my $output = run-example($example-name, script-args => "--dir=$tempdir");
    is($output, $expected-output, $example-name);
}, "09-05-all-files-dir.p6";

subtest {
    plan 1;

    my $example-name = "09-06-filenames-matching-pattern.p6";
    my $tempdir = tempdir;
    my @filenames = <alice.pl bob.pl charlie.pl eve.pl>;
    for @filenames -> $file {
        my $path = $*SPEC.catdir($tempdir, $file);
        my $fh = open $path, :w or die "$!";
        $fh.close;
    }
    my $expected-output = @filenames.join("\n");

    my $output = run-example($example-name, script-args => "--dir=$tempdir");
    is($output.chomp, $expected-output, $example-name);
}, "09-06-filenames-matching-pattern.p6";

subtest {
    plan 1;

    my $example-name = "09-07-all-files-process.p6";
    my $tempdir = tempdir;
    my @subdirs = <a b c d>;
    my @files = <alice bob charlie eve>;
    my $expected-output;
    for @subdirs -> $subdir {
        mkdir $*SPEC.catdir($tempdir, $subdir);
        for @files -> $file {
            my $path = $*SPEC.catdir($tempdir, $subdir, $subdir ~ $file);
            $expected-output ~= $path ~ "\n";
            my $fh = open $path, :w or die "$!";
            $fh.close;
        }
    }

    my $output = run-example($example-name, script-args => "--dir=$tempdir");
    is($output, $expected-output, $example-name);
}, "09-07-all-files-process.p6";

subtest {
    plan 1;

    my $example-name = "09-10-filename-splitting.p6";
    my $tempdir = tempdir;
    $tempdir ~~ s!'//'!'/'!;
    my $filename = $*SPEC.catdir($tempdir, "alice.pl");
    my $expected-output = qq:to/EOD/;
    basename: alice.pl
    dirname: $tempdir
    extension: pl
    EOD

    my $output = run-example($example-name, script-args => "--file=$filename");
    is($output, $expected-output, $example-name);
}, "09-10-filename-splitting.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/09directories";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
