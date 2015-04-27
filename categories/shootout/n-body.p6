use v6;

=begin pod

=TITLE Perform an N-body simulation of the Jovian planets

=AUTHOR Daniel Carrera

L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=nbody>

USAGE: perl6 n-body.p6 1000

Expected output

    -0.169075164
    -0.169087605

=end pod

constant SOLAR_MASS     = (4 * pi * pi);
constant DAYS_PER_YEAR  = 365.24e0;

constant $LAST = 4;

# @ns = ( sun, jupiter, saturn, uranus, neptune )
my Num @XS = (0e0, 4.84143144246472090e+00, 8.34336671824457987e+00,    1.28943695621391310e+01, 1.53796971148509165e+01);
my Num @YS = (0e0, -1.16032004402742839e+00, 4.12479856412430479e+00,   -1.51111514016986312e+01, -2.59193146099879641e+01);
my Num @ZS = (0e0, -1.03622044471123109e-01, -4.03523417114321381e-01,  -2.23307578892655734e-01, 1.79258772950371181e-01);
my Num @VXS = map {$^a * DAYS_PER_YEAR},
                (0, 1.66007664274403694e-03, -2.76742510726862411e-03, 2.96460137564761618e-03, 2.68067772490389322e-03);
my Num @VYS = map {$^a * DAYS_PER_YEAR},
                (0, 7.69901118419740425e-03, 4.99852801234917238e-03, 2.37847173959480950e-03, 1.62824170038242295e-03);
my Num @VZS = map {$^a * DAYS_PER_YEAR},
                (0, -6.90460016972063023e-05, 2.30417297573763929e-05, -2.96589568540237556e-05, -9.51592254519715870e-05);
my Num @MASS = map {$^a * SOLAR_MASS},
                (1, 9.54791938424326609e-04, 2.85885980666130812e-04, 4.36624404335156298e-05, 5.15138902046611451e-05);

sub MAIN($num-bodies = 1000) {
    offset_momentum();
    printf "%.9f\n", energy();

    my $N = $num-bodies;

    # This does not, in fact, consume N*4 bytes of memory
    for (1..$N) {
        advance(0.01);
    }
    printf "%.9f\n", energy();
}

sub advance($dt) {
    my Num ($dx, $dy, $dz, $distance, $mag);

    for 0..$LAST -> $i {
        for ($i+1)..$LAST -> $k {
            $dx = @XS[$i] - @XS[$k];
            $dy = @YS[$i] - @YS[$k];
            $dz = @ZS[$i] - @ZS[$k];
            $distance = sqrt($dx * $dx + $dy * $dy + $dz * $dz);
            $mag = $dt / ($distance * $distance * $distance);
            @VXS[$i] -= $dx * @MASS[$k] * $mag;
            @VXS[$k] += $dx * @MASS[$i] * $mag;
            @VYS[$i] -= $dy * @MASS[$k] * $mag;
            @VYS[$k] += $dy * @MASS[$i] * $mag;
            @VZS[$i] -= $dz * @MASS[$k] * $mag;
            @VZS[$k] += $dz * @MASS[$i] * $mag;
        }

        # We're done with planet $i at this point
        @XS[$i] += $dt * @VXS[$i];
        @YS[$i] += $dt * @VYS[$i];
        @ZS[$i] += $dt * @VZS[$i];
    }
}

sub energy {
    my Num ($e, $dx, $dy, $dz, $distance);

    $e = 0e0;
    for 0..$LAST -> $i {
        $e += 0.5 * @MASS[$i] *
        (@VXS[$i]*@VXS[$i] + @VYS[$i]*@VYS[$i] + @VZS[$i]*@VZS[$i]);
        for ($i + 1)..$LAST -> $k {
            $dx = @XS[$i] - @XS[$k];
            $dy = @YS[$i] - @YS[$k];
            $dz = @ZS[$i] - @ZS[$k];
            $distance = sqrt($dx * $dx + $dy * $dy + $dz * $dz);
            $e -= (@MASS[$i] * @MASS[$k]) / $distance;
        }
    }
    return $e;
}

sub offset_momentum {
    my Num ($px, $py, $pz) = (0e0, 0e0, 0e0);

    for 0..$LAST -> $i {
        $px += @VXS[$i] * @MASS[$i];
        $py += @VYS[$i] * @MASS[$i];
        $pz += @VZS[$i] * @MASS[$i];
    }
    @VXS[0] = - $px / SOLAR_MASS;
    @VYS[0] = - $py / SOLAR_MASS;
    @VZS[0] = - $pz / SOLAR_MASS;
}

# vim: expandtab shiftwidth=4 ft=perl6
