use v6;

my $n = $*IN.get.Int;

sub postfix:<!>($n) { [*] 1 .. $n }
sub C($n, $k) {
    state %cache;
    %cache{$n}{$k} //=
    $k == 1 ?? $n !! C($n, $k-1)*($n-$k+1) div $k 
}

say gather for 1 .. 2*$n -> $k {
    take .log / log 10 given 1/2**(2*$n) * [+] map { C 2*$n, $_ }, $k .. 2*$n;
}

# vim: ft=perl6
