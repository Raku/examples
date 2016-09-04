use v6;

=begin pod

=TITLE Odd elimination

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=539>

Start from an ordered list of all integers from 1 to n. Going from left to
right, remove the first number and every other number afterward until the
end of the list. Repeat the procedure from right to left, removing the right
most number and every other number from the numbers left. Continue removing
every other numbers, alternating left to right and right to left, until a
single number remains.

Starting with n = 9, we have:
B<1> 2    B<3> 4    B<5> 6 B<7> 8 B<9>
2    B<4> 6    B<8>
B<2> 6
6

Let C<P(n)> be the last number left starting with a list of length C<n>.

Let C<S(n) = sum(k=1..n, P(k))>.

You are given C<P(1)=1>, C<P(9)=6>, C<P(1000)=510>, C<S(1000)=268271>.

Find C<S(10^18) mod 987654321>.

=end pod

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
