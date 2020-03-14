use v6;

=begin pod

=TITLE Pandigital Fibonacci ends

=AUTHOR Moritz Lenz

L<https://projecteuler.net/problem=104>

The Fibonacci sequence is defined by the recurrence relation:

    Fₙ = Fₙ₋₁ + Fₙ₋₂, where F₁ = 1 and F₂ = 1.

It turns out that F₅₄₁, which contains 113 digits, is the first Fibonacci
number for which the last nine digits are 1-9 pandigital (contain all the
digits 1 to 9, but not necessarily in order). And F₂₇₄₉, which contains 575
digits, is the first Fibonacci number for which the first nine digits are
1-9 pandigital.

Given that Fₖ is the first Fibonacci number for which the first nine digits
AND the last nine digits are 1-9 pandigital, find k.

=end pod

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

# vim: expandtab shiftwidth=4 ft=perl6
