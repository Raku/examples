use v6;

sub pper($n, $k) { [*] $n-$k+1 .. $n }
say pper(| $*IN.get.split: " ") % 1_000_000;

# vim: ft=perl6
