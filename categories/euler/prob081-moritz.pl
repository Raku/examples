use v6;

=begin pod

=TITLE Path sum: two ways

=AUTHOR Moritz Lenz

L<https://projecteuler.net/problem=81>

In the 5 by 5 matrix below, the minimal path sum from the top left to the
bottom right, by only moving to the right and down, is indicated in bold
and is equal to 2427.

⎛B<131> 673    234    103    18⎞
⎜B<201> B<96>  B<342> 965    150⎟
⎜630    803    B<746> B<422> 111⎟
⎜537    699    497    B<121> 956⎟
⎝805    732    524    B<37>  B<331>⎠

Find the minimal path sum, in matrix.txt, a 31K text file containing a 80 by
80 matrix, from the top left to the bottom right by only moving right and
down.

=end pod

my @m;

my $matrix-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'matrix.txt');
my $f = open $matrix-file or die "Can't open file for reading: $!";
for $f.lines -> $line {
    @m.push: $line.comb(/\d+/).Array.item;
}
$f.close;

my ($max-x, $max-y) = +@m[0], +@m;

@m[0][$_] += @m[0][$_-1] for 1..$max-x-1;
@m[$_][0] += @m[$_-1][0] for 1..$max-y-1;

for 1..$max-y-1 -> $y {
    for 1..$max-x-1 -> $x {
        @m[$y][$x] += @m[$y-1][$x] min @m[$y][$x-1];
    }
}

say @m[*-1][*-1];

# vim: expandtab shiftwidth=4 ft=perl6
