# 09-basic.t - SVG-Tiny-1.2 section 9 - Basic Shapes

use Test::Differences;
use SVG::Tiny;

plan 7;

my SVG::Tiny $image;
my Str       $expected;
my Str       $output;

# 9.2 rect
$image .= new( viewbox=>'0 0 100 100' );
$image.rect( x=>10, y=>11, width=>12, height=>13, rx=>6, ry=>5, fill=>'#4c8',
 stroke=>'fuchsia', stroke_width=>4 );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<rect x="10" y="11" width="12" height="13" rx="6" ry="5" fill="#4c8" stroke="fuchsia" stroke-width="4" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "rect with all parameters" );

$image .= new( viewbox=>'0 0 1200 400' );
$image.rect( x=>100, y=>100, width=>400, height=>200, fill=>'green' );
$image.g( transform=>'translate(700 210) rotate(-30)',
    $image.rect( x=>0, y=>0, width=>400, height=>200, fill=>'none',
                 stroke=>'green', stroke_width=>30 )
);
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 1200 400" xmlns="http://www.w3.org/2000/svg">
<rect x="100" y="100" width="400" height="200" fill="green" />
<g transform="translate(700 210) rotate(-30)">
<rect x="0" y="0" width="400" height="200" fill="none" stroke="green" stroke-width="30" />
</g>
</svg>]; # almost the same as spec example 09_02.svg
$output = $image.svg;
eq_or_diff( $output, $expected, "rect rounded and transformed" );

# 9.3 circle
$image .= new( viewbox=>'0 0 100 100' );
$image.circle( cx=>9, cy=>8, r=>7, fill=>'lime', stroke=>'olive',
 stroke_width=>6 );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<circle cx="9" cy="8" r="7" fill="lime" stroke="olive" stroke-width="6" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "circle with all parameters" );

# 9.4 ellipse
$image .= new( viewbox=>'0 0 100 100' );
$image.ellipse( cx=>5, cy=>4, rx=>6, ry=>2, fill=>'teal', stroke=>'navy',
 stroke_width=>3 );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<ellipse cx="5" cy="4" rx="6" ry="2" fill="teal" stroke="navy" stroke-width="3" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "ellipse with all parameters" );

# 9.5 line
$image .= new( viewbox=>'0 0 100 100' );
$image.line( x1=>4, y1=>5, x2=>6, y2=>7, stroke_width=>3,
 stroke=>'silver' );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<line x1="4" y1="5" x2="6" y2="7" stroke-width="3" stroke="silver" />
</svg>]; # subset of spec example 09_05.svg
$output = $image.svg;
eq_or_diff( $output, $expected, "line" );

# 9.6 polyline
$image .= new( viewbox=>'0 0 100 100' );
$image.polyline( points=>'10,10 10,20 20,20', stroke=>'maroon',
 stroke_width=>3 );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<polyline points="10,10 10,20 20,20" stroke="maroon" stroke-width="3" />
</svg>]; # subset of spec example 09_06.svg
$output = $image.svg;
eq_or_diff( $output, $expected, "polyline" );

# 9.7 polygon
$image .= new( viewbox=>'0 0 100 100' );
$image.polygon( points=>'11,12 11,22 21,22', stroke=>'gray',
 stroke_width=>5 );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<polygon points="11,12 11,22 21,22" stroke="gray" stroke-width="5" />
</svg>]; # subset of spec example 09_06.svg
$output = $image.svg;
eq_or_diff( $output, $expected, "polygon" );

=begin pod

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=end pod
