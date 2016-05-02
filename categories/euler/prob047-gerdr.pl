use v6;

=begin pod

=TITLE Distinct primes factors

=AUTHOR Gerhard R

L<https://projecteuler.net/problem=47>

The first two consecutive numbers to have two distinct prime factors are:

14 = 2 × 7
15 = 3 × 5

The first three consecutive numbers to have three distinct prime factors
are:

644 = 2² × 7 × 23
645 = 3 × 5 × 43
646 = 2 × 17 × 19.

Find the first four consecutive integers to have four distinct prime
factors. What is the first of these numbers?

To run this example, the associated C file (prob047-gerdr.c) needs to be
compiled into a shared object library.

In GCC this is achieved like so:

    $ gcc --std=c99 -fPIC -c -o prob047-gerdr.o prob047-gerdr.c
    $ gcc -shared -o prob047-gerdr.so prob047-gerdr.o

After which, the example can be run as expected:

    $ perl6 prob047-gerdr.pl

=end pod

use NativeCall;

sub factors(int32 $n) returns int32 is native($*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'prob047-gerdr')) { * }

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
