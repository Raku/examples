my @dna = map { [.comb] }, lines;

my @c = @dna[0][];

for ^@c -> $c {
    my $count = 0;
    my @line = map { $count += my $x = +so .[$c] eq @c[$c]; $x }, @dna;
    say @line.join if 1 < $count < @dna-1;
}
     
# vim: ft=perl6
