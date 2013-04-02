my @dna = map { [.comb] }, lines;

my @c = @dna[0][];

for ^@c -> $c {
    my @line = map { +so .[$c] eq @c[$c] }, @dna;
    say @line.join if 1 < ([+] @line) < @dna-1;
}

# vim: ft=perl6
