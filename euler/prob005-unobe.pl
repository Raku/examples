use v6;

my @numbers = 2..20;
my @factors = @numbers;
my %factor;
for @numbers -> $num is rw {
    for @factors -> $factor is rw {
        next if $num % $factor;
        my $exp = 0;
        while $num div= $factor { $exp++; }
        if !%factor{$factor} || %factor{$factor} < $exp {
            %factor{$factor} = $exp;
        };
    }
}
say [*] %factor.map({ .key**.value });
