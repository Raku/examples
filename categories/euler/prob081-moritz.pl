use v6;

my @m;

my $matrix-file = $*PROGRAM_NAME.IO.dirname ~ '/matrix.txt';
my $f = open $matrix-file or die "Can't open file for reading: $!";
for $f.lines {
    @m.push: [ .comb(/\d+/) ];
}
$f.close;

my ($max-x, $max-y) = +@m[0], +@m;

say "Size: $max-x x $max-y";

@m[0][$_] += @m[0][$_-1] for 1..$max-x-1;
@m[$_][0] += @m[$_-1][0] for 1..$max-y-1;

for 1..$max-y-1 -> $y {
    for 1..$max-x-1 -> $x {
        @m[$y][$x] += @m[$y-1][$x] min @m[$y][$x-1];
    }
}

say @m[*-1][*-1];

# vim: expandtab shiftwidth=4 ft=perl6
