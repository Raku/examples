use v6;

=begin pod

=head1 NAME

run-all-examples.pl - run all current Perl 6 examples

=head1 SYNOPSIS

    $ perl6 run-all-examples.pl [--category=<category-name>]

=head1 DESCRIPTION

A script to run all current Perl 6 examples in the C<perl6-examples>
repository and print their output.  This is useful to check if the examples
compile and/or work as expected.

=end pod

use File::Find;

my @categories = qw{
    99-problems
    best-of-rosettacode
    cookbook
    euler
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
    01-read-from-terminal.pl
    24-game.pl
    balanced-brackets.pl
    create-a-two-dimensional-array-at-runtime.pl
    event10-dwhipp.p6
    event005-eric256.pl
    event008-eric256.pl
    event008-j1n3l0.pl
};

# skip memory hogs
my @memory-hogs = qw{
    prob012-polettix.pl
    prob014-felher.pl
    prob027-shlomif.pl
    hailstone-sequence.pl
};

# skip long-running examples
my @long-runners = qw{
    prob010-polettix.pl
    prob092-moritz.pl
    prob104-moritz.pl
    prob149-shlomif.pl
    prob189-shlomif.pl
};

# skip examples requiring internet access
my @internet-required = qw{
    mprt-grondilu.pl
    dbpr-grondilu.pl
};

# skip examples requiring shared libraries
my @shared-lib-required = qw{
    lcsq-grondilu.pl
};

my @examples-to-skip = @interactive-examples,
                        @memory-hogs,
                        @long-runners,
                        @internet-required,
                        @shared-lib-required,
                        ;

sub MAIN (:$category) {
    @categories = [$category] if $category;
    my $base-dir = $*CWD;
    for @categories -> $dir {
        my @example-files = find(dir => "categories/" ~ $dir).grep(/<?!after 'p5'>.p(l|6)$/).sort;
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
