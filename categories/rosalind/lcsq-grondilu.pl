use v6;

=begin pod

=TITLE Finding a Shared Spliced Motif

=AUTHOR grondilu

L<http://rosalind.info/problems/lcsq/>

Sample input

    >Rosalind_23
    AACCTTGG
    >Rosalind_64
    ACACTGTGA

Sample output

    AACTG

Note: the C<lcsq> shared library needs to be built first.  For example, on a
Linux system use the following commands:

    $ gcc --std=c99 -fPIC -c -o lcsq.o lcsq.c
    $ gcc -shared -o lcsq.so lcsq.o

=end pod

use NativeCall;
sub lcsq(Str $, Str $ --> Str) is native('./lcsq') {*}

say lcsq |gather for slurp.match:
/ ^^ '>Rosalind_' <digit>+ \n (<[\nACGT]>*) /, :g {
    take ~.[0].subst(/\n/,'', :g);
}

# vim: expandtab shiftwidth=4 ft=perl6
