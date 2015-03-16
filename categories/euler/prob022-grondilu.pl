use v6;
my $i = 1;
constant A = 'A'.ord - 1;
my $names-file = $*PROGRAM_NAME.IO.dirname ~ "/names.txt";
my $data = slurp $names-file;
my @names = sort $data.subst('"', '', :g).split(',');
say [+] gather
for @names {
    take $i++ * [+] .comb».ord »-» A;
}

# vim: expandtab shiftwidth=4 ft=perl6
