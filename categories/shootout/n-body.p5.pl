# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# contributed by Christoph Bauer
# converted into Perl by Márton Papp
# fixed and cleaned up by Danny Sauer
# optimized by Jesse Millikan

use constant PI            => 3.141592653589793;
use constant SOLAR_MASS    => (4 * PI * PI);
use constant DAYS_PER_YEAR => 365.24;

#  Globals for arrays... Oh well.
#  Almost every iteration is a range, so I keep the last index rather than a count.
my (@xs, @ys, @zs, @vxs, @vys, @vzs, @mass, $last);

sub advance($)
{
  my ($dt) = @_;
  my ($mm, $mm2, $j, $dx, $dy, $dz, $distance, $mag);

#  This is faster in the outer loop...
  for (0..$last) {
#  But not in the inner loop. Strange.
    for ($j = $_ + 1; $j < $last + 1; $j++) {
      $dx = $xs[$_] - $xs[$j];
      $dy = $ys[$_] - $ys[$j];
      $dz = $zs[$_] - $zs[$j];
      $distance = sqrt($dx * $dx + $dy * $dy + $dz * $dz);
      $mag = $dt / ($distance * $distance * $distance);
      $mm = $mass[$_] * $mag;
      $mm2 = $mass[$j] * $mag;
      $vxs[$_] -= $dx * $mm2;
      $vxs[$j] += $dx * $mm;
      $vys[$_] -= $dy * $mm2;
      $vys[$j] += $dy * $mm;
      $vzs[$_] -= $dz * $mm2;
      $vzs[$j] += $dz * $mm;
    }

# We're done with planet $_ at this point
# This could be done in a seperate loop, but it's slower
    $xs[$_] += $dt * $vxs[$_];
    $ys[$_] += $dt * $vys[$_];
    $zs[$_] += $dt * $vzs[$_];
  }
}

sub energy
{
  my ($e, $i, $dx, $dy, $dz, $distance);

  $e = 0.0;
  for $i (0..$last) {
    $e += 0.5 * $mass[$i] *
          ($vxs[$i] * $vxs[$i] + $vys[$i] * $vys[$i] + $vzs[$i] * $vzs[$i]);
    for ($i + 1..$last) {
      $dx = $xs[$i] - $xs[$_];
      $dy = $ys[$i] - $ys[$_];
      $dz = $zs[$i] - $zs[$_];
      $distance = sqrt($dx * $dx + $dy * $dy + $dz * $dz);
      $e -= ($mass[$i] * $mass[$_]) / $distance;
    }
  }
  return $e;
}

sub offset_momentum
{
  my ($px, $py, $pz) = (0.0, 0.0, 0.0);

  for (0..$last) {
    $px += $vxs[$_] * $mass[$_];
    $py += $vys[$_] * $mass[$_];
    $pz += $vzs[$_] * $mass[$_];
  }
  $vxs[0] = - $px / SOLAR_MASS;
  $vys[0] = - $py / SOLAR_MASS;
  $vzs[0] = - $pz / SOLAR_MASS;
}

# @ns = ( sun, jupiter, saturn, uranus, neptune )
@xs = (0, 4.84143144246472090e+00, 8.34336671824457987e+00,
1.28943695621391310e+01, 1.53796971148509165e+01);
@ys = (0, -1.16032004402742839e+00, 4.12479856412430479e+00,
-1.51111514016986312e+01, -2.59193146099879641e+01);
@zs = (0, -1.03622044471123109e-01, -4.03523417114321381e-01,
-2.23307578892655734e-01, 1.79258772950371181e-01);
@vxs = map {$_ * DAYS_PER_YEAR}
  (0, 1.66007664274403694e-03, -2.76742510726862411e-03,
2.96460137564761618e-03, 2.68067772490389322e-03);
@vys = map {$_ * DAYS_PER_YEAR}
  (0, 7.69901118419740425e-03, 4.99852801234917238e-03, 2.37847173959480950e-03,
1.62824170038242295e-03);
@vzs = map {$_ * DAYS_PER_YEAR}
  (0, -6.90460016972063023e-05, 2.30417297573763929e-05,
-2.96589568540237556e-05, -9.51592254519715870e-05);
@mass = map {$_ * SOLAR_MASS}
  (1, 9.54791938424326609e-04, 2.85885980666130812e-04, 4.36624404335156298e-05,
5.15138902046611451e-05);

$last = @xs - 1;

offset_momentum();
printf ("%.9f\n", energy());

my $n = $ARGV[0];

# This does not, in fact, consume N*4 bytes of memory
for (1..$n){
  advance(0.01);
}

printf ("%.9f\n", energy());

