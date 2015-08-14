use v6;

=begin pod

=TITLE Powerful digit counts

=AUTHOR Moritz Lenz

L<https://projecteuler.net/problem=63>

The 5-digit number, 16807=7^5, is also a fifth power. Similarly, the 9-digit
number, 134217728=8^9, is a ninth power.

How many n-digit positive integers exist which are also an nth power?

=end pod

sub MAIN(Bool :$verbose = False) {
    my $count = 0;
    for 1..9 -> $x {
        for 1..200 -> $y {
            if ($x**$y).chars == $y {
                say "$x**$y" if $verbose;
                $count++;
            }
        }
    }
    say $count;
    say "missing bigint support: answer should be 49" if $verbose;
}

# vim: expandtab shiftwidth=4 ft=perl6
