use v6;

=begin pod

=TITLE Scoring probabilities

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=286>

Barbara is a mathematician and a basketball player. She has found that the probability of scoring a point when shooting from a distance x is exactly (1 - x/q), where q is a real constant greater than 50.

During each practice run, she takes shots from distances x = 1, x = 2, ..., x = 50 and, according to her records, she has precisely a 2 % chance to score a total of exactly 20 points.

Find q and give your answer rounded to 10 decimal places.

=end pod

sub calc($q)
{
    my @probs = (1.0);

    for 1 .. 50 -> $x
    {
        my $p = 1 - $x / $q;
        my @new_probs;
        for 0 .. $x -> $i
        {
            @new_probs.push(
                (($i == $x) ?? 0 !! @probs[$i] * (1-$p))
                    +
                (($i == 0) ?? 0 !! ($p * @probs[$i-1]))
            );
        }
        @probs = @new_probs;
    }
    return @probs[20];
}

sub MAIN(:$verbose = False) {
    my $l = 50.0;
    my $h = 100000.0;
    my $Epsilon = 1e-16;
    my $wanted = 0.02;
    BIN_SEARCH:
    while (1)
    {
        my $m = (($l + $h) / 2);
        my $v_m = calc($m);
        printf("f(%.40f) = %.40f\n", $m, $v_m);
        my $delta = abs($v_m - $wanted);
        # say ("Delta = $delta");
        if ($delta < $Epsilon)
        {
            last BIN_SEARCH;
        }
        if ($v_m > $wanted)
        {
            $l = $m;
        }
        else
        {
            $h = $m;
        }
    }
}
