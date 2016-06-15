use v6;

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

            if (@c[1] == 1)
            {
                if (@c[0] != 0)
                {
                    die "Dont know how to handle.";
                }
                $x_coeff += $m;
            }
            elsif (@c[1] == 2)
            {
                if (@c[0] != 1)
                {
                    die "Dont know how to handle.";
                }
                $x2_p_1_coeff += $m;
            }
            elsif (@c[1] == 4)
            {
                if (@c[0] == 1)
                {
                    $x2_p_1_coeff += ($m +< 1);
                    $x_coeff -= $m;
                }
                elsif (@c[0] == 3)
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

my $mult = 4;
while (1)
{
    say lookup($mult);
    $mult +<= 1;
}

