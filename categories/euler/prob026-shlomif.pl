use v6;

=begin pod

=TITLE Reciprocal cycles

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=26>

A unit fraction contains 1 in the numerator. The decimal representation of
the unit fractions with denominators 2 to 10 are given:

    1/2 =       0.5
    1/3 =       0.(3)
    1/4 =       0.25
    1/5 =       0.2
    1/6 =       0.1(6)
    1/7 =       0.(142857)
    1/8 =       0.125
    1/9 =       0.(1)
    1/10        =       0.1

Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be
seen that 1/7 has a 6-digit recurring cycle.

Find the value of d < 1000 for which 1/d contains the longest recurring
cycle in its decimal fraction part.

=end pod

sub find_cycle_len(Int $n) returns Int {
    my %states;

    my $r = 1;
    my $count = 0;

    while ! ( %states{$r}:exists ) {
        # $*ERR.say( "Trace: N = $n ; R = $r" );
        %states{$r} = $count++;
        ($r *= 10) %= $n;
    }

    return $count - %states{$r};
}

my $max_cycle_len = -1;
my $max_n;

for (2 .. 999) -> $n {
    if ((my $cycle_len = find_cycle_len($n)) > $max_cycle_len) {
        $max_n = $n;
        $max_cycle_len = $cycle_len;
    }
}

say "The recurring cycle is $max_n, and the cycle length is $max_cycle_len";

# vim: expandtab shiftwidth=4 ft=perl6
