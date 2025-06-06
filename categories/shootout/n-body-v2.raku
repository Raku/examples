use v6;

=begin pod

=TITLE Perform an N-body simulation of the Jovian planets

=AUTHOR Gerhard R

L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=nbody>

USAGE: perl6 n-body-v2.p6 [N=1000] [dt=1e-2]

Expected output

    -0.169075164
    -0.169087605

=end pod

constant SOLAR_MASS = 4 * pi * pi;
constant DAYS_PER_YEAR = 365.24e0;

class Vector {
    has Num ($.x, $.y, $.z);
    submethod BUILD(:$!x = 0e0, :$!y = 0e0, :$!z = 0e0) {}

    method addmul(Vector $v, Num $s) {
        $!x = $!x + $v.x * $s;
        $!y = $!y + $v.y * $s;
        $!z = $!z + $v.z * $s;
    }
}

multi infix:<**>(Vector $_, 2 --> Num) { .x * .x + .y * .y + .z * .z }
multi infix:<**>(Vector $_, 1 --> Num) { sqrt $_ ** 2 }
multi infix:<**>(Vector $_, Num $x --> Num) { ($_ ** 2) ** ($x / 2e0) }

multi infix:<->(Vector $a, Vector $b --> Vector) {
    Vector.new: :x($a.x - $b.x), :y($a.y - $b.y), :z($a.z - $b.z)
}

class Body {
    has Num $.m;
    has Vector ($.r, $.v);
}

enum Planet <Sun Jupiter Saturn Uranus Neptune>;

my Body @bodies = (
    ( # Sun
        1e0, [0e0 xx 3], [0e0 xx 3]),
    ( # Jupiter
        9.54791938424326609e-04,
        [ 4.84143144246472090e+00,
         -1.16032004402742839e+00,
         -1.03622044471123109e-01],
        [ 1.66007664274403694e-03,
          7.69901118419740425e-03,
         -6.90460016972063023e-05]),
    ( # Saturn
        2.85885980666130812e-04,
        [ 8.34336671824457987e+00,
          4.12479856412430479e+00,
         -4.03523417114321381e-01],
        [-2.76742510726862411e-03,
          4.99852801234917238e-03,
          2.30417297573763929e-05]),
    ( # Uranus
        4.36624404335156298e-05,
        [ 1.28943695621391310e+01,
         -1.51111514016986312e+01,
         -2.23307578892655734e-01],
        [ 2.96460137564761618e-03,
          2.37847173959480950e-03,
         -2.96589568540237556e-05]),
    ( # Neptune
        5.15138902046611451e-05,
        [ 1.53796971148509165e+01,
         -2.59193146099879641e+01,
          1.79258772950371181e-01],
        [ 2.68067772490389322e-03,
          1.62824170038242295e-03,
         -9.51592254519715870e-05])
).map: -> ($m, [$x, $y, $z], [$vx, $vy, $vz]) {
    Body.new:
        :m($m * SOLAR_MASS),
        :r(Vector.new: :$x, :$y, :$z),
        :v(Vector.new:
            :x($vx * DAYS_PER_YEAR),
            :y($vy * DAYS_PER_YEAR),
            :z($vz * DAYS_PER_YEAR))
};

my Body @pairs;
for 1..^+@bodies -> $i {
    for ^$i -> $j {
        @pairs.push: @bodies[$i], @bodies[$j];
    }
}

sub total-energy(--> Num) {
      ([+] @bodies.map: { 0.5e0 * .m * .v ** 2 })
    - ([+] @pairs.map: -> $a, $b { ($a.m * $b.m) / ($a.r - $b.r) ** 1 })
}

sub total-momentum(--> Vector) {
    my Vector $p .= new;
    $p.addmul(.v, .m) for @bodies;
    return $p;
}

sub step(Num $dt) {
     for @pairs -> $a, $b {
        my Vector $dr = $a.r - $b.r;
        my Num $mag = $dt * $dr ** -3e0;
        $a.v.addmul($dr, $b.m * $mag * -1e0);
        $b.v.addmul($dr, $a.m * $mag);
     }

     .r.addmul(.v, $dt) for @bodies;
}

.v.addmul(total-momentum, -1e0 / .m)
    given @bodies[Sun];

sub MAIN(Int $n = 1000, Num $dt = 1e-2) {
    printf "%.9f\n", total-energy;
    step $dt for ^$n;
    printf "%.9f\n", total-energy;
}

# vim: expandtab shiftwidth=4 ft=perl6
