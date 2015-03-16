use v6;
my $i = 1;
constant A = 'A'.ord - 1;
my $names-file = $*PROGRAM_NAME.IO.dirname ~ "/names.txt";
say [+] gather
for sort slurp $names-file {
    take $i++ * [+] .comb».ord »-» A;
}

# vim: expandtab shiftwidth=4 ft=perl6
