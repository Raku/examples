my ($n, $m) = get.words;

my @population = 1, 0 xx ($m-1);
for 1 .. $n-1 -> \n {
    @population.unshift: [+] @population[1..*-1];  # reproduction
    @population.pop;                               # death
}

say [+] @population;


# vim: ft=perl6
