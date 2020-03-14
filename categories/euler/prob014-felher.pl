use v6;

=begin pod

=TITLE Longest Collatz sequence

=AUTHOR Felix Herrmann

L<https://projecteuler.net/problem=14>

The following iterative sequence is defined for the set of positive integers:

n → n/2 (n is even)
n → 3n + 1 (n is odd)

Using the rule above and starting with 13, we generate the following sequence:
13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1

It can be seen that this sequence (starting at 13 and finishing at 1)
contains 10 terms. Although it has not been proved yet (Collatz Problem), it
is thought that all starting numbers finish at 1.

Which starting number, under one million, produces the longest chain?

NOTE: Once the chain starts the terms are allowed to go above one million.

=end pod

# this program takes quite a few minutes on my machine

my Int multi sub collatz(Int $n where * %% 2) { $n div 2;   }
my Int multi sub collatz(Int $n             ) { 3 * $n + 1; }

my Int sub get-length(Int $n)  {
    state Int %length{Int} = 1 => 1;
    my $result = %length{$n} // 1 + get-length collatz $n;
    %length{$n} = $result;
    $result;
}

my $max = 0;
my $start = 0;
for 1 ..^ 1_000_000 -> $n {
    say "Starting number: $n" unless $n % 10000; #just for progress
    my $length = get-length $n;

    if $length > $max {
        $start = $n;
        $max = $length;
    }
}

say "The starting number $start produces a sequence of length $max";

# vim: expandtab shiftwidth=4 ft=perl6
