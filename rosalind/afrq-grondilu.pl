use v6;

my @A = get.split(' ')».Num;

sub afrq($r) { 1 - (1 - sqrt $r)**2 }

say @A».&afrq;

# 0.532 0.75 0.914
# vim: ft=perl6
