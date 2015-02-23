use v6;

=begin pod

=head1 NAME

run-all-examples.pl - run all current Perl 6 examples

=head1 SYNOPSIS

    $ perl6 run-all-examples.pl [--example-dir=<dir-name>]

=head1 DESCRIPTION

A script to run all current Perl 6 examples in the C<perl6-examples>
repository and print their output.  This is useful to check if the examples
compile and/or work as expected.

=end pod

use File::Find;

my @example-dirs = qw{
    99-problems
    best-of-rosettacode
    cookbook
    euler
    games
    interpreters
    module-management
    parsers
    perlmonks
    rosalind
    shootout
    tutorial
    wsg
};

# skip interactive examples; need to work out how to pass input data to
# interactive examples
my @interactive-examples = qw{
    24-game.pl
    balanced-brackets.pl
    create-a-two-dimensional-array-at-runtime.pl
};

# skip memory hogs
my @memory-hogs = qw{
    prob012-polettix.pl
    prob014-felher.pl
    prob027-shlomif.pl
};

# skip long-running examples
my @long-runners = qw{
    prob010-polettix.pl
    prob104-moritz.pl
    prob149-shlomif.pl
    prob189-shlomif.pl
};

my @examples-to-skip = @interactive-examples, @memory-hogs, @long-runners;

sub MAIN (:$example-dir) {
    @example-dirs = [$example-dir] if $example-dir;
    my $base-dir = $*CWD;
    for @example-dirs -> $dir {
        my @example-files = find(dir => $dir).grep(/.pl$/).sort;
        for @example-files -> $example {
            my $example-dir = $example.dirname;
            my $example-name = $example.basename;
            next if grep $example-name, @examples-to-skip;
            say $example-dir ~ "/" ~ $example-name;
            chdir $example-dir;
            qqx{perl6 $example-name}.say;
            chdir $base-dir;
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
