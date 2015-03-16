use v6;
use NativeCall;

=begin pod

To run this example, the associated C file (prob047-gerdr.c) needs to be
compiled into a shared object library.

In GCC this is achieved like so:

    gcc --std=c99 -fPIC -c -o prob047-gerdr.o prob047-gerdr.c
    gcc -shared -o prob047-gerdr.so prob047-gerdr.o

After which, the example can be run as expected:

    perl6 prob047-gerdr.pl

=end pod

sub factors(int $n) returns int is native($*PROGRAM_NAME.IO.dirname ~ '/prob047-gerdr') { * }

sub MAIN(Int $N = 4) {
    my int $n = 2;
    my int $i = 0;

    while $i != $N {
        $i = factors($n) == $N ?? $i + 1 !! 0;
        $n = $n + 1;
    }

    say $n - $N;
}

# vim: expandtab shiftwidth=4 ft=perl6
