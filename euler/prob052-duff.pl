use v6;


sub log10($n) { return log($n) / log(10) }

my $mag = 1;        # current power of 10
my $n = $mag;       # number to start searching from
loop {
    my $s = (2*$n).comb.sort;
    last if 
        $s eq (3*$n).comb.sort &&
        $s eq (4*$n).comb.sort && 
        $s eq (5*$n).comb.sort && 
        $s eq (6*$n).comb.sort;
    $n++;
    if log10(6*$n).Int > log10(2*$n).Int {
        $mag *= 10;
        $n = $mag;
    }
}
say $n;
