use v6;

=begin pod

=TITLE Independent Segregation of Chromosomes

=AUTHOR L. Grondin

L<http://rosalind.info/problems/indc/>

Sample input

    5

Sample output

    0.000 -0.004 -0.024 -0.082 -0.206 -0.424 -0.765 -1.262 -1.969 -3.010

=end pod

my $n = 5;

sub C($n, $k) {
    state %cache;
    %cache{$n}{$k} //=
        $k == 1 ?? $n !! C($n, $k-1)*($n-$k+1) div $k;
}

my @results = gather for 1 .. 2*$n -> $k {
    take .log / log 10 given 1/2**(2*$n) * [+] map { C 2*$n, $_ }, $k .. 2*$n;
}

say @results.fmt("%.3f");

# vim: expandtab shiftwidth=4 ft=perl6
