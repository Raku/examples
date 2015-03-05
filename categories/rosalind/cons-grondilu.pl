use v6;

my @default-data = qw{
    ATCCAGCT
    GGGCAACT
    ATGGATCT
    AAGCAACC
    TTGGAACT
    ATGCCATT
    ATGGCACT
};

my \N = @default-data.pick.chars;

my %profile;
%profile{$_} = [0 xx N] for <A C G T>;

for @default-data[] {
    my @dna = .comb;
    for kv classify { @dna[$_] }, ^@dna -> $k, $v {
        %profile{$k}[$v[]]»++;
    }
}
my @profile = %profile<A C G T>;

say my $consensus = [~] gather
for ^N -> \c {
    my $max = max map { @profile[$_][c] }, ^4;
    take <A C G T>[$_] given first { @profile[$_][c] == $max }, ^4;
}

say .key, ': ', @profile[.value] for enum <A C G T>;

# vim: expandtab shiftwidth=4 ft=perl6
