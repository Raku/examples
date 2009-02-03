# 05-basic.t - SVG-Tiny-1.2 section 9 - Basic Shapes

use Test::Differences;
use SVG::Tiny;

plan 6;

my SVG::Tiny $image;
my Str $expected;
my Str $output;

# 9.2 rect
$image .= new( viewbox=>'0 0 100 100' );
$image.rect(); # if no parameters are passed in, none should come out
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<rect />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "rect with no parameters" );

$image .= new( viewbox=>'0 0 100 100' );
$image.rect( width=>12, height=>13, x=>10, y=>11, fill=>'maroon', ry=>5,
 stroke=>'fuchsia', rx=>6, stroke_width=>4 ); # all parameters in jumbled order
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<rect x="10" y="11" width="12" height="13" rx="6" ry="5" fill="maroon" stroke="fuchsia" stroke-width="4" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "rect with all parameters" );

# 9.3 circle
$image .= new( viewbox=>'0 0 100 100' );
$image.circle();
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<circle />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "circle with no parameters" );

$image .= new( viewbox=>'0 0 100 100' );
$image.circle( stroke_width=>8, cy=>10, r=>10, stroke=>'olive', cx=>10,
 fill=>'lime' ); # all parameters in jumbled order
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<circle x="10" y="10" width="10" fill="lime" stroke="olive" stroke-width="8" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "circle with all parameters" );

# 9.4 ellipse
$image .= new( viewbox=>'0 0 100 100' );
$image.ellipse();
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<ellipse />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "ellipse with no parameters" );

$image .= new( viewbox=>'0 0 100 100' );
$image.ellipse( ry=>2, stroke_width=>3, fill=>'teal', cy=>4,
 stroke=>'navy', cx=>5, rx=>6 ); # all parameters in jumbled order
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<ellipse cx="5" cy="4" rx="6" ry="2" fill="teal" stroke="navy" stroke-width="3" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "ellipse with all parameters" );

=begin pod

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=end pod
