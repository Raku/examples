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
    prob014-felher.pl
    prob027-shlomif.pl
};

# skip long-running examples
my @long-runners = qw{
    prob104-moritz.pl
    prob149-shlomif.pl
    prob189-shlomif.pl
};

my @examples-to-skip = @interactive-examples, @memory-hogs, @long-runners;

sub MAIN (:$example-dir) {
    @example-dirs = [$example-dir] if $example-dir;
    for @example-dirs -> $dir {
        my @example-files = find(dir => $dir).grep(/.pl$/).sort;
        for @example-files -> $example {
            next if grep $example.basename, @examples-to-skip;
            say $dir ~ "/" ~ $example.basename;
            qqx{perl6 $example}.say;
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
