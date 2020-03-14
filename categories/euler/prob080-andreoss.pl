use v6;

=begin pod

=TITLE Square root digital expansion

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=80>

It is well known that if the square root of a natural number is not an
integer, then it is irrational.  The decimal expansion of such square roots
is infinite without any repeating pattern at all.  The square root of two is
1.41421356237309504880..., and the digital sum of the first one hundred
decimal digits is 475.

For the first one hundred natural numbers, find the total of the digital
sums of the first one hundred decimal digits for all the irrational square
roots.

The following algorithm was used for the solution:
L<http://www.afjarvis.staff.shef.ac.uk/maths/jarvisspec02.pdf>

=end pod

my constant $limit = 100;

sub sqrt-subtraction($n) {
    my Int $a = $n * 5 ;
    my Int $b = 5;
    while $b < 10 * 10 ** $limit {
        given $a <=> $b {
            when More | Same {
                # replace a with a − b, and add 10 to b.
                $a -=  $b;
                $b += 10;
            }
            when Less {
                # add two zeros to a
                $a *= 100;
                # add a zero to b just before the final digit (which will always be ‘5’).
                $b = ($b - (my $x = $b % 10)) * 10 + $x;
            }
        }
    }
    $b;
}

sub MAIN(Bool :$verbose = False) {
    say [+] do for 1 ... 100 -> $n {
        next if $n.sqrt.floor ** 2 == $n;
        my $x = [+] $n.&sqrt-subtraction.comb[^$limit];
        say "$n $x"  if $verbose;
        $x;
    }
    say "Done in {now - INIT now}" if $verbose;
}

# vim: expandtab shiftwidth=4 ft=perl6
