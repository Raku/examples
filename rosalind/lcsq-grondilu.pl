use v6;

use NativeCall;
sub lcsq(Str $, Str $ --> Str) is native('./lcsq') {*}

say lcsq |gather for slurp.match:
/ ^^ '>Rosalind_' <digit>+ \n (<[\nACGT]>*) /, :g {
    take ~.[0].subst(/\n/,'', :g);
}

# vim: expandtab shiftwidth=4 ft=perl6
