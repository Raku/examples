use v6;

use Test;
use File::Temp;

plan 5;

my $skip = True;

subtest {
    plan 1;

    my $example-name = "09-01-get-set-filetime.pl";
    my $expected-output = rx/':dt($(' \d+\.0 ', Bool::False))'/;

    my $output = run-example($example-name);
    like($output, $expected-output, $example-name);
}, "09-01-get-set-filetime.pl";

subtest {
    plan 1;

    my $example-name = "09-05-all-files-dir.pl";
    my $tempdir = tempdir;
    my @filenames = <alice bob charlie eve>;
    my $expected-output;
    for @filenames -> $file {
        my $path = $*SPEC.catdir($tempdir, $file);
        $expected-output ~= $path.IO.perl ~ "\n";
        my $fh = open $path, :w or die "$!";
        $fh.close;
    }

    my $output = run-example($example-name, script-args => "--dir=$tempdir");
    is($output, $expected-output, $example-name);
}, "09-05-all-files-dir.pl";

subtest {
    plan 1;

    my $example-name = "09-06-filenames-matching-pattern.pl";
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
}, "09-06-filenames-matching-pattern.pl";

subtest {
    plan 1;

    my $example-name = "09-07-all-files-process.pl";
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
}, "09-07-all-files-process.pl";

subtest {
    plan 1;

    my $example-name = "09-10-filename-splitting.pl";
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
}, "09-10-filename-splitting.pl";

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
