use v6;
my $i = 1;
constant A = 'A'.ord - 1;
say [+] gather
for sort eval slurp 'names.txt' {
    take $i++ * [+] .comb».ord »-» A;
}