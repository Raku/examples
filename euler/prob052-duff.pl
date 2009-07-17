use v6;


sub log10($n) { return log($n) / log(10) }

my $s = '';
my $mag = 1;
my $x = $mag;
loop {
    my $n = 2 * $x; my $s = $n.comb.sort;
    last if 
        $s eq (3*$x).comb.sort &&
        $s eq (4*$x).comb.sort && 
        $s eq (5*$x).comb.sort && 
        $s eq (6*$x).comb.sort;
    $x++;
    if log10(6*$x).int > log10(2*$x).int {
        $mag *= 10;
        $x = $mag;
    }
}

say $x;

