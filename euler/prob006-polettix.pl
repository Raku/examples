# The sum of the squares of the first ten natural numbers is,
# 
#    1**2 + 2**2 + ... + 10**2 = 385
# 
# The square of the sum of the first ten natural numbers is,
# 
#    (1 + 2 + ... + 10)**2 = 55**2 = 3025
# 
# Hence the difference between the sum of the squares of the first
# ten natural numbers and the square of the sum is 3025 - 385 = 2640.
# 
# Find the difference between the sum of the squares of the first
# one hundred natural numbers and the square of the sum.

use v6;

# Upper bound optionally taken from command line, defaults to
# challenge's request
my $upper = shift(@*ARGS) || 100;

# This is quite straightforward: the sum of the first N positive
# integers is easily computed as (N + 1) * N / 2, hence the square
# is straightforward. We then subtract the square of each single
# one to get the final result.
my $result = (($upper + 1) * $upper / 2) ** 2;
$result -= $_ ** 2 for 1 .. $upper;
say $result;

#######################################################################
# Another way:
# I added this because of the mathematical beautity revealing the similarity between the two.

#       use List::Utils qw/sum reduce/                  # Perl5 code...
my @l = 1..100;
#       my $sum_of_squares = reduce {$a + $b**2} 0, @l; # Perl5 code...
#       my $square_of_sum = (sum @l)**2;                # Perl5 code...
my $sum_of_squares = [+] @l X** 2;      # Perl6 code is much clearer...
my $square_of_sum = ([+] @l) ** 2;      # Compare with the above line, and note the similarity!
say $square_of_sum - $sum_of_square;
