use v6;

=begin pod

Introduction to Alternative Splicing

http://rosalind.info/problems/aspc/

Expected output from default input data:

    42

=end pod

sub MAIN($n = 6, $m = 3) {
    my $sum = my $C =  ([*] $n-$m+1 .. $n) div [*] 1 .. $m;
    for $m+1 .. $n -> $k { $sum += $C = $C * ($n - $k + 1) div $k }
    say $sum % 1_000_000;
}

# vim: expandtab shiftwidth=4 ft=perl6
