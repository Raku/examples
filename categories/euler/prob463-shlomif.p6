use v6;

=begin pod

=TITLE A weird recurrence relation

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=463>

The function C<f> is defined for all positive integers as follows:

    f(1)=1
    f(3)=3
    f(2n)=f(n)
    f(4n + 1)=2f(2n + 1) - f(n)
    f(4n + 3)=3f(2n + 1) - 2f(n)

The function C<S(n)> is defined as C<∑_i=1..q f(i)>.

    S(8)=22 and S(100)=3604.

Find C<S(3**37)>. Give the last 9 digits of your answer.


Dedicated to the memory of Christina Grimmie
(L<https://en.wikipedia.org/wiki/Christina_Grimmie>),
see: L<https://www.youtube.com/watch?v=kYX8sjIzjGw>.
   -- shlomif

=end pod

my $debug = False;

class Poly
{
    has $.mult;
    # Coefficients.
    has @.c;

    method inc()
    {
        return Poly.new(mult => $.mult, c => [@.c[0]+@.c[1], @.c[1]]);
    }

    method double()
    {
        return Poly.new(mult => $.mult, c => [@.c[0], @.c[1]*2]);
    }
}

my %cache;
{
    my $mult = 4;
    my @polys = (
        Poly.new(mult => 6, c => [1,2]),
        Poly.new(mult => -2, c => [0,1]),
    );

    %cache = ("$mult" => @polys);
}

sub lookup_proto($mult)
{
    return %cache{$mult} //= sub {
        my $polys = lookup_proto($mult / 2);
        my @extend = @$polys.map( { .inc });
        my @new_polys = flat(@$polys, @extend).map({ .double });

        my $x2_p_1_coeff = 0;
        my $x_coeff = 0;
        for @new_polys -> $p
        {
            my $m = $p.mult;
            my @c = @($p.c);

            while (@c[1] > 1 and @c[0] % 2 == 0)
            {
                for @c -> $x is rw
                {
                    $x /= 2;
                }
            }

            if @c[1] == 1
            {
                if @c[0] != 0
                {
                    die "Dont know how to handle.";
                }
                $x_coeff += $m;
            }
            elsif @c[1] == 2
            {
                if @c[0] != 1
                {
                    die "Dont know how to handle.";
                }
                $x2_p_1_coeff += $m;
            }
            elsif @c[1] == 4
            {
                if @c[0] == 1
                {
                    $x2_p_1_coeff += ($m +< 1);
                    $x_coeff -= $m;
                }
                elsif @c[0] == 3
                {
                    $x2_p_1_coeff += ($m * 3);
                    $x_coeff -= ($m +< 1);
                }
                else
                {
                    die "Dont know how to handle.";
                }
            }
            else
            {
                die "Dont know how to handle.";
            }
        }
        my @ret =
        (
            Poly.new(mult => $x2_p_1_coeff, c => [1,2]),
            Poly.new(mult => $x_coeff, c => [0,1]),
        );

        return @ret;
    }.();
}

sub lookup($mult)
{
    my $ret = lookup_proto($mult);
    return @($ret).map({ .mult });
}

if $debug
{
    my $mult = 4;
    while (1)
    {
        say lookup($mult);
        $mult +<= 1;
    }
}

my $MOD = 1_000_000_000;

sub _cache(%h, $key, $promise)
{
    my $ret = %h{$key};

    if !defined($ret)
    {
        $ret = ($promise.() % $MOD);
        %h{$key} = $ret;
    }

    return $ret;
}

my %f_cache;

sub f_mod($n)
{
    if $n < 1
    {
        die "Foo";
    }

    return _cache(%f_cache, $n, sub {
        if $n == 1
        {
            return 1;
        }
        elsif $n == 3
        {
            return 3;
        }
        elsif ($n +& 1) == 0
        {
            return f_mod($n +> 1);
        }
        elsif ($n +& 3) == 1
        {
            return (2 * f_mod(($n +> 1) + 1) - f_mod($n +> 2));
        }
        else
        {
            return (3 * f_mod(($n +> 1)) - 2 * f_mod($n +> 2));
        }
        }
    );
}

sub s_bruteforce
{
    my ($n) = @_;

    my $s = 0;

    for 1 .. $n -> $i
    {
        ($s += f_mod($i)) %= $MOD;
    }

    return $s;
}

sub s_smart($start, $end)
{
    state %s_cache;

    # say "s->e : $start->$end";
    return _cache(%s_cache, "$start|$end", sub {
        if $start > $end
        {
            return 0;
        }
        if $start == $end
        {
            return f_mod($start);
        }
        if $end <= 8
        {
            return s_bruteforce($end) - s_bruteforce($start - 1);
        }
        if ($start +& 0b11) != 0
        {
            return (f_mod($start) + s_smart($start+1, $end));
        }
        if ($end +& 0b11) != 0b11
        {
            return (f_mod($end) + s_smart($start, $end-1));
        }
        my $power2 = ((($start +& ($start-1)) != 0) ?? 1+(($start-1)+^$start) !! $start);
        my $new_end = $start + $power2 - 1;
        while ($new_end > $end)
        {
            $new_end = $start + ($power2 +>= 1) - 1;
        }
        my @c = lookup($power2);
        my $m = $start / $power2;
        return (@c[0] * f_mod($m*2+1) + @c[1] * f_mod($m) + s_smart($new_end+1, $end));
        },
    );
}

if $debug
{
    my $want = 0;
    for 1 .. 100_000 -> $n
    {
        if $n % 1_000 == 0
        {
            say "Reached n=$n";
        }
        ($want += f_mod($n)) %= $MOD;
        my $have = s_smart(1, $n);
        if $want != $have
        {
            die "want=$want have=$have n=$n!";
        }
    }
}

{
    say "S(3 ** 37) = ", s_smart(1, 3 ** 37);
}

# vim: expandtab shiftwidth=4 ft=perl6
