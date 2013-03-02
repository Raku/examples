use NativeCall;
sub lcsq(Str $, Str $ --> Str) is native('./lcsq') {*}

say lcsq |gather for slurp.match:
/ ^^ '>Rosalind_' <digit>+ \n (<[\nACGT]>*) /, :g {
    take ~.[0].subst(/\n/,'', :g);
}

# vim: ft=perl6
