use v6;

=begin pod

=TITLE Rabbits and Recurrence Relations

=AUTHOR grondilu

L<http://rosalind.info/problems/fib/>

Sample input

    5 3

Sample output

    19

=end pod

my ($n, $k) = get.words;
my @fib := 1, 1, * * $k + * ... *;

say @fib[$n-1];

# vim: expandtab shiftwidth=4 ft=perl6
