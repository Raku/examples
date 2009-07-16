use v6;

my $s = '';
my $x = 1;
loop {
    my $n = 2 * $x; my $s = $n.comb.sort;
    last if 
        $s eq (3*$x).comb.sort &&
        $s eq (4*$x).comb.sort && 
        $s eq (5*$x).comb.sort && 
        $s eq (6*$x).comb.sort;
    $x++;
}

say $x;

