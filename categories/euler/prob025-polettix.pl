use v6;

=begin pod

=TITLE 1000-digit Fibonacci number

=AUTHOR Flavio Poletti

L<https://projecteuler.net/problem=25>

The Fibonacci sequence is defined by the recurrence relation:

Fn = Fn1 + Fn2, where F1 = 1 and F2 = 1.
Hence the first 12 terms will be:

   F1 = 1
   F2 = 1
   F3 = 2
   F4 = 3
   F5 = 5
   F6 = 8
   F7 = 13
   F8 = 21
   F9 = 34
   F10 = 55
   F11 = 89
   F12 = 144

The 12th term, F12, is the first term to contain three digits.

What is the first term in the Fibonacci sequence to contain 1000 digits?

=end pod

sub MAIN(Int :$length = 1000, Bool :$boring = False) {
    if $boring {
        my ($x, $y, $c) = (1, 1, 2);
        ($x, $y, $c) = ($y, $x + $y, $c + 1) while $y.chars < $length;
        $c.say;
        return;
    }

    my @fibs = 0, 1, *+* ... *;
    ((1..*).grep:{@fibs[$_].chars == $length})[0].say;
    return;
}

# vim: expandtab shiftwidth=4 ft=perl6
