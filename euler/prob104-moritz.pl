use v6;

say "please be patient, this is going to take a while";

sub is-pandigital (Str $i) {
    return 1 unless $i.chars == 10;
    my %seen;
    for $i.split: '' {
        return if %seen{$_};
        %seen{$_} = 1;
    }
    return 1;
}

my @fib = 1, 2;
my $n = 3;

while 1 {
    my $f = @fib[0] + @fib[1];
    @fib.push: $f;
    shift @fib;
    my $first = try {$f.substr(0, 10)};
    my $last  = try {$f.substr(-10)  };
    next unless $first && $last;
    if (is-pandigital(~$first) && is-pandigital(~$last)) {
        say $f;
        say $n;
        exit;
    }
    $n++;
    say $n unless $n % 1e4;
}


# vim: ft=perl6
