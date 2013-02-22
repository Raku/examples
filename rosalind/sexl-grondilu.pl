use v6;

say map { 2*$^x*(1-$x) }, get.split(' ')».Num;

