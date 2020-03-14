use v6;

=begin pod

=TITLE Independent Alleles

=AUTHOR L. Grondin

L<http://rosalind.info/problems/lia/>

Sample input

    2 1

Sample output

    0.684

=end pod

sub MAIN(Str $data = "2 1") {
    my ($k, $N) = $data.split(" ")».Int;

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

    my $total = 2**$k;
    my $result = [+] map -> $i {
        (1-$p)**($total - $i)*$p**$i * binomialcoefficient( $total, $i )
    }, $N .. $total;

    say $result.fmt("%.3f");
}

sub postfix:<!>($a) { [*] 1..$a }
sub binomialcoefficient($n, $k) {
    $n! / (($n - $k)! * $k!);
}

# vim: expandtab shiftwidth=4 ft=perl6
