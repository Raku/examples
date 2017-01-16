use v6;

=begin pod

=TITLE Palindromic sums

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=125>

Palindromic sums

The palindromic number 595 is interesting because it can be written as the sum
of consecutive squares: 62 + 72 + 82 + 92 + 102 + 112 + 122.

There are exactly eleven palindromes below one-thousand that can be written as
consecutive square sums, and the sum of these palindromes is 4164. Note that 1
= 02 + 12 has not been included as this problem is concerned with the squares
of positive integers.

Find the sum of all the numbers less than 108 that are both palindromic and can
be written as the sum of consecutive squares.

=end pod

my $debug = False;

my $LIMIT = 100_000_000;

my $sqrt_limit = $LIMIT.sqrt.Int;

my $found = SetHash.new;
my $sum_found = 0;

for 1 .. $sqrt_limit -> $start
{
    my $sum = $start**2;

    for $start+1 .. $sqrt_limit -> $end
    {
        $sum += $end**2;
        if $sum > $LIMIT
        {
            last;
        }

        if $sum.flip eq $sum
        {
            if not $sum ∈ $found
            {
                say "Found $sum";
                $found{$sum} = True;
                $sum_found += $sum;
            }
        }
    }
}

say "Sum found = $sum_found";
