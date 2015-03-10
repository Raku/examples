use v6;
my $i = 1;
constant A = 'A'.ord - 1;
say [+] gather
for sort slurp 'names.txt' {
    take $i++ * [+] .comb».ord »-» A;
}

# vim: expandtab shiftwidth=4 ft=perl6
