use v6;

=begin pod

=TITLE Non-abundant sums

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=23>

A perfect number is a number for which the sum of its proper divisors is
exactly equal to the number. For example, the sum of the proper divisors of
28 would be 1 + 2 + 4 + 7 + 14 = 28, which means that 28 is a perfect
number.

A number n is called deficient if the sum of its proper divisors is less
than n and it is called abundant if this sum exceeds n.

As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest
number that can be written as the sum of two abundant numbers is 24. By
mathematical analysis, it can be shown that all integers greater than 28123
can be written as the sum of two abundant numbers.  However, this upper
limit cannot be reduced any further by analysis even though it is known that
the greatest number that cannot be expressed as the sum of two abundant
numbers is less than this limit.

Find the sum of all the positive integers which cannot be written as the sum
of two abundant numbers.

Based on:
L<https://bitbucket.org/shlomif/project-euler/src/aa5eecd18f0825901afeb3c54dcda0da79ac3576/project-euler/23/euler-23-4.pl?at=default>

=end pod

my @divisors_sums;
@divisors_sums[1] = 0;

my $MAX = 28_123;
for (1 .. ($MAX +> 1)) -> $div {
    loop (my $prod = ($div +< 1); $prod <= $MAX; $prod += $div) {
        @divisors_sums[$prod] += $div;
    }
}

# Memoized.
#
my @is_abundant_sum;

my @abundants;
my $total = 0;
for (1 .. $MAX) -> $num {
    if @divisors_sums[$num] > $num {
        @abundants.push($num);
        # The sub { ... } and return are a workaround for the fact that Rakudo
        # Perl 6 does not have last LABEL yet.
        my $c = sub {
            for @abundants -> $i {
                if ((my $s = $i + $num) > $MAX) {
                    return;
                }
                else {
                    if (! @is_abundant_sum[$s]) {
                        $total += $s;
                        @is_abundant_sum[$s] = True;
                    }
                }
            }
        };

        $c();
    }
}

say ((((1 + $MAX) * $MAX) +> 1)-$total);

# vim: expandtab shiftwidth=4 ft=perl6
