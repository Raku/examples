use v6;

say map { 2*$^x*(1-$x) }, get.split(' ')».Num;

# vim: expandtab shiftwidth=4 ft=perl6
