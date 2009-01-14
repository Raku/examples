
# There is no IO::Dir::open implemented in Rakudo yet, and I don't know how
# to make this output become an IO stream to implement it according to
# spec...so just use PIR directly for now
my @files = q:PIR {
    $P1 = new ['OS']
    $P2 = $P1.'readdir'('.') # change to whatever the script directory is
    %r = 'list'($P2)
};
my $output = 'firstlines.out';

# only select .txt files
for @files.grep: { .match(/\.txt $$/) } {
    my $inputfh = open $_, :r;
    my $outputfh = open $output, :a;
    $outputfh.say( $($inputfh.readline) ); # $(...) forces item context
    .close for $inputfh, $outputfh;
}

