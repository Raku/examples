use v6;
my @s = $*IN.lines;
my \N = @s.pick.chars;

my %profile;
%profile{$_} = [0 xx N] for <A C G T>;

for @s[] {
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

# vim: ft=perl6
