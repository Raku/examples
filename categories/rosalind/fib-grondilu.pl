use v6;

=begin pod

=TITLE Rabbits and Recurrence Relations

=AUTHOR L. Grondin

L<http://rosalind.info/problems/fib/>

Sample input

    5 3

Sample output

    19

=end pod

sub MAIN(Int $n = 5, Int $k = 3) {
    my @fib = 1, 1, * * $k + * ... *;

    say @fib[$n-1];
}

# vim: expandtab shiftwidth=4 ft=perl6
