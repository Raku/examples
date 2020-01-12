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

# skip interactive examples; need to work out how to pass input data to
# interactive examples
my @interactive-examples = qw{
    01-read-from-terminal.pl
    15-05-get-char.p6
    24-game.pl
    balanced-brackets.pl
    create-a-two-dimensional-array-at-runtime.pl
    event10-dwhipp.p6
    event005-eric256.pl
    event008-eric256.pl
    event008-j1n3l0.pl
    16-18-catch-control-c.p6
    19-01cgi-script.p6
    calc.p6
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
    prob060-andreoss.pl
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

my @examples-to-skip = flat |@interactive-examples,
                       |@memory-hogs,
                       |@long-runners,
                       |@internet-required,
                       |@shared-lib-required;

sub MAIN (:$category) {
    my @categories = $category ?? ["categories/$category"] !! 'categories'.IO.dir.grep({ $_.basename !~~ 'games' });
    for @categories -> $dir {
        my @example-files = find(:$dir, name => / <?!after 'p5'> .p(l|6) $ /).sort;
        for @example-files -> $example {
            my $example-dir = $example.dirname;
            my $example-name = $example.basename;
            next if grep $example-name, @examples-to-skip;
            say $example-dir ~ "/" ~ $example-name;
            indir($example-dir, {
                shell "$*EXECUTABLE.absolute() $example-name";
            });
        }
    }
}
