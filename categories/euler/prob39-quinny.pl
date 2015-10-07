use v6;

=begin pod

=TITLE Integer right triangles

=AUTHOR Quinn Perfetto

L<https://projecteuler.net/problem=39>

If p is the perimeter of a right angle triangle with integral length sides, {a,b,c}, there are exactly three solutions for p = 120.

{20,48,52}, {24,45,51}, {30,40,50}

For which value of p ≤ 1000, is the number of solutions maximised?

=end pod

sub isTriple($a, $b, $c) {
    ($a * $a) + ($b * $b) == ($c * $c);
}

sub solutionsFor($p) {
    [+] gather for 1 .. $p -> $i {
        for ($i + 1) .. ($p - $i) -> $j {
            my $k = $p - $i - $j;
            take isTriple($i, $j, $k)
        }
    }
}

my $max = 0;
my $perim = 0;
for 3 .. 1000 {
    my $check = solutionsFor $_;
    if $check > $max {
        $max = $check;
        $perim = $_;
    }
}

say $perim;
