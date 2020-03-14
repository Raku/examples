use v6;

=begin pod

=TITLE Generates the Mandelbrot Set fractal

=AUTHOR Rodrigo Siqueira (@rsiqueira)

To be submitted to "The Computer Language Benchmarks Game", to test Perl6 speed / performance 
in comparison with other programming languages.

L<https://benchmarksgame.alioth.debian.org/u32q/mandelbrot-description.html>
L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=mandelbrot>
L<http://benchmarksgame.alioth.debian.org/u64/performance.php?test=mandelbrot>

USAGE: perl6 mandelbrot.p6 200 > image.pbm

=end pod



constant $MAXITER = 50;
constant $xmin = -1.5;
constant $ymin = -1.0;

my $w = (@*ARGS[0] || 200);
my $h = $w;

my Rat $invN = 2/$w;

print "P4\n$w $h\n"; # PBM image header

my Int $bit_num = 0;

my Int $is_set=1;

my Int $byte = 0;

for (0..$h-1) -> $y {

  my Rat $y_coord = $y * $invN + $ymin;

  for 0..$w-1 -> $x {

    my Rat $x_coord = $x * $invN + $xmin;

    my Complex $C = $x_coord + $y_coord\i;

    my Complex $z=0+0i;

    for (0..$MAXITER) { # Iterate

      $z = $z * $z + $C;

      if ($z.abs > 4) { # Outer area of the Mandelbrot Set
        $is_set = 0;
        last;
      }

    }

#    if ($is_set) { # Inner area of the Mandelbrot Set
#      print "o";
#    } else {       # Outer area
#      print ".";
#    }

    $bit_num++;

    $byte = $byte +< 1;
    if ($is_set) {
      $byte = $byte +| 1;
    }

    if ($bit_num == 8) {

      $bit_num = 0;
      my $buf = Buf.new( $byte );
      $*OUT.write($buf);
      $byte = 0;

    } elsif ($x == $w-1) { # (8 - $w%8) bits to fill out the last byte in the row

      $byte = $byte +< (8 - $w%8);
      my $buf = Buf.new( $byte );
      $*OUT.write($buf);
      $byte = 0;
      $bit_num = 0;
    }

    $is_set=1;

  } # Next x

#  print "\n";

} # Next y
