use v6;

=begin pod

=TITLE Smallest multiple

=AUTHOR David Romano

L<https://projecteuler.net/problem=5>

2520 is the smallest number that can be divided by each of the numbers from
1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the
numbers from 1 to 20?

=end pod

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

# vim: expandtab shiftwidth=4 ft=perl6
