use v6;

=begin pod

=TITLE Mortal Fibonacci Rabbits

=AUTHOR L. Grondin

L<http://rosalind.info/problems/fibd/>

Sample input

    6 3

Sample outut

    4

=end pod

sub MAIN(Int $n = 6, Int $m = 3) {
    my @population = (1, 0 xx ($m-1)).flat;
    for 1 .. $n-1 -> \n {
        @population.unshift: [+] @population[1..*-1];  # reproduction
        @population.pop;                               # death
    }

    say [+] @population;
}

# vim: expandtab shiftwidth=4 ft=perl6
