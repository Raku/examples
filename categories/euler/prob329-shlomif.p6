#!/usr/bin/perl6

use v6;

my @is_prime = (False, False, (map { $_.is-prime ?? True !! False }, 2 .. 500), False);

my @p_letter = (map { $_ ?? 'P' !! 'N' }, @is_prime);

my @init_probab = (0, (map { FatRat.new(1, 500) }, 1 .. 500) , 0);

my @up_step_probab = (0, 1, (map { FatRat.new(1, 2) }, 2 .. 499) , 0 , 0);
my @down_step_probab = (0, 0, (map { FatRat.new(1, 2) }, 2 .. 499) , 1, 0 );
my $s = 'PPPPNNPPPNPPNPN';

my @probab = @init_probab;
my $T_frac = FatRat.new(2, 3);
my $F_frac = FatRat.new(1, 3);

sub f($k, $idx, @step)
{
    return
    (
        @step[$idx] * @probab[$idx]
        * ($k eq @p_letter[$idx] ?? $T_frac !! $F_frac)
    );
}

for $s.comb() -> $k
{
    my @next_probab = (0, (map { my $i = $_;
                (
                f($k, $i - 1, @up_step_probab)
                +
                f($k, $i + 1, @down_step_probab)
                );
        }, 1 .. 500), 0);

    @probab = @next_probab;
}

my $sum = FatRat.new(0,1);

for @probab -> $x
{
    $sum += $x;
}

say $sum.numerator , '/', $sum.denominator;
