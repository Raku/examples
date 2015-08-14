use v6;

=begin pod

=TITLE Names scores

=AUTHOR L. Grondin

L<https://projecteuler.net/problem=22>

Using names.txt a 46K text file containing over five-thousand first names,
begin by sorting it into alphabetical order. Then working out the
alphabetical value for each name, multiply this value by its alphabetical
position in the list to obtain a name score.

For example, when the list is sorted into alphabetical order, COLIN, which
is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So, COLIN
would obtain a score of 938 × 53 = 49714.

What is the total of all the name scores in the file?

=end pod

my $i = 1;
constant A = 'A'.ord - 1;
my $names-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "names.txt");
my $data = slurp $names-file;
my @names = sort $data.subst('"', '', :g).split(',');
say [+] gather
for @names {
    take $i++ * [+] .comb».ord »-» A;
}

# vim: expandtab shiftwidth=4 ft=perl6
