#!/usr/bin/perl6

use v6;

my @ar;
for 1 .. 64 -> $i
{
    my $mask = 0b1;
    for 0 , 2 ... $i - 2 -> $offset
    {
        $mask +|= (0b1 +< $offset);
    }
    @ar.push({ 't' => (1 +< $i), 'h' => (+^(1 +< ($i-1))), 'o' => $mask});
}

# print @ar.perl;
sub p_l($l)
{
    for @ar -> $e
    {
        if $l < $e{'t'}
        {
            return (($l +& $e{'h'} ) +| $e{'o'});
        }
    }
}

sub s_from_2power_to_next($exp)
{
    my $mymin = 1 +< $exp;
    my $mymax = ((1 +< ($exp+1)) - 1);

    my $cnt = ($mymax - $mymin + 1);
    my $naive_sum = ( ((($mymax +& (+^$mymin))+0) * $cnt) +> 1 );
    my $s = $naive_sum;

    for (0, 2 ... ($exp - 1)) -> $b_exp
    {
        my $b_pow = 1 +< $b_exp;
        $s += (($b_pow * $cnt) +> 1);
    }

    return $s + $cnt;
}

sub prefix_S_from_2power_to_next($prefix, $exp)
{
    my $mymin = $prefix +< $exp;
    my $mymax = $mymin + ((1 +< $exp) - 1);

    my $cnt = ($mymax - $mymin + 1);

    my $mymask = $mymin;
    my $b_exp = 0;
    my $b_pow = 1;
    while $b_exp < $exp
    {
        $b_exp += 2;
        $b_pow +<= 2;
    }
    while $b_pow < $mymin
    {
        $mymask +|= $b_pow;
        $b_exp += 2;
        $b_pow +<= 2;
    }

    $b_pow = 1;
    while $b_pow <= $mymask
    {
        $b_pow +<= 1;
    }

    $mymask +&= (+^($b_pow +> 1));

    return s_from_2power_to_next($exp) + $mymask * $cnt;
}

sub fast_S($MAX)
{
    my $s = 1;
    my $mymin = 2;
    my $mymax = 3;
    my $b_exp = 1;
    while $mymax < $MAX
    {
        $s += s_from_2power_to_next($b_exp);
        $mymin +<= 1;
        $b_exp += 1;
        $mymax = (($mymin +< 1) - 1);
    }

    $s += 1 + p_l($mymin);

    my $digit = $mymin +> 1;
    $b_exp -= 1;
    # $mymin is what we reached.
    while $mymin < $MAX
    {
        if (($mymin +| $digit) <= $MAX)
        {
            my $prev_mymin = $mymin;
            $mymin +|= $digit;
            my $res = prefix_S_from_2power_to_next(($prev_mymin +> $b_exp), $b_exp);
            $s += $res;
            $s += p_l($mymin);
            $s -= p_l($prev_mymin);
        }
        $digit +>= 1;
        $b_exp -= 1;
    }
    if ($mymin < $MAX)
    {
        $s += 1 + p_l($MAX);
    }


    return $s;
}

my $myMAX = 1000000000000000000;
my $myRES = fast_S($myMAX);
say "S({$myMAX}) = {$myRES} (mod = {$myRES % 987654321})";
