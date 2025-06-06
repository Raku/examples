use v6;

=begin pod

=TITLE P33 - Determine whether two positive integer numbers are coprime.

=AUTHOR Philip Potter

=head1 Specification

    P33 (*) Determine whether two positive integer numbers are coprime.
      Two numbers are coprime if their greatest common divisor equals 1.

=head1 Example

    > say coprime(35,64)
    1

=end pod

# This is from P32-rhebus.pl
sub gcds (Int $a, Int $b) {
    return ($a, $b, *%* ... 0)[*-2];
}

sub coprime (Int $a, Int $b) { gcds($a,$b) == 1 }

say coprime(35,64);

# Another option is to make coprime an operator:
# (theoretically 'our' is unnecessary but rakudo needs it
our sub infix:<coprime> (Int $a, Int $b) { gcds($a,$b) == 1 }

# All adjacent fibonacci pairs are coprime.
# We can test a number of fibonacci pairs at once
# with the hyper operator »coprime«

my @fib = (1,2,3,5,8,13,21,34,55);
say $_ for @fib[0..^+@fib-1] »coprime« @fib[1..^+@fib];

# And here's another famous series:
my @pow = (1,2,4,{$_*2} ... 4096);
say $_ for @pow[0..^+@pow-1] »coprime« @pow[1..^+@pow];

# vim: expandtab shiftwidth=4 ft=perl6
