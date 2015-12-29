use v6;

=begin pod

=TITLE Prime Frog

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=329>

Susan has a prime frog.

Her frog is jumping around over 500 squares numbered 1 to 500. He can only
jump one square to the left or to the right, with equal probability, and he
cannot jump outside the range [1;500].  (if it lands at either end, it
automatically jumps to the only available square on the next move.)

When he is on a square with a prime number on it, he croaks 'P' (PRIME) with
probability 2/3 or 'N' (NOT PRIME) with probability 1/3 just before jumping
to the next square.  When he is on a square with a number on it that is not
a prime he croaks 'P' with probability 1/3 or 'N' with probability 2/3 just
before jumping to the next square.

Given that the frog's starting position is random with the same probability
for every square, and given that she listens to his first 15 croaks, what is
the probability that she hears the sequence PPPPNNPPPNPPNPN?

Give your answer as a fraction p/q in reduced form.

=end pod

my @is_prime = flat (False, False, (map { $_.is-prime ?? True !! False }, 2 .. 500), False);

my @p_letter = flat (map { $_ ?? 'P' !! 'N' }, @is_prime);

my @init_probab = flat (0, (map { FatRat.new(1, 500) }, 1 .. 500) , 0);

my @up_step_probab = flat (0, 1, (map { FatRat.new(1, 2) }, 2 .. 499) , 0 , 0);
my @down_step_probab = flat (0, 0, (map { FatRat.new(1, 2) }, 2 .. 499) , 1, 0 );
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
    my @next_probab = flat (0, (map { my $i = $_;
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
