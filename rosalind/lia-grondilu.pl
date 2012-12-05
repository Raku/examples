use v6;

my ($k, $N) = $*IN.get.split(" ")».Int;

my %p = <AA Aa aa> Z=> <0 1 0>;
for ^$k {
    %p = 
    :AA(2 * [+] %p<AA Aa aa> Z* <1/2 1/4 0>),
    :Aa(2 * [+] %p<AA Aa aa> Z* <1/2 1/2 1/2>),
    :aa(2 * [+] %p<AA Aa aa> Z* <0 1/4 1/2>),
    ;
}
die unless 2**$k == [+] %p.values;
my $p = %p<Aa> / 2**$k;
$p *= $p;

sub postfix:<!>($a) { [*] 1..$a }
sub binomialcoefficient($n, $k) {
    $n! 
    / (($n - $k)! * $k!);
}
my $total = 2**$k;
say [+] map -> $i { (1-$p)**($total - $i)*$p**$i * binomialcoefficient( $total, $i ) }, $N .. $total;

# vim: ft=perl6
