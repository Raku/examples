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

sub MAIN (:$example-dir) {
    @example-dirs = [$example-dir] if $example-dir;
    for @example-dirs -> $dir {
        my @example-files = dir($dir).sort.grep: /\.pl$/;
        for @example-files -> $example {
            say $dir ~ "/" ~ $example.basename;
            qqx{perl6 $example}.say;
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
