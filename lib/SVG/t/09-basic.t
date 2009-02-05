# 09-basic.t - SVG-Tiny-1.2 section 9 - Basic Shapes

use Test::Differences;
use SVG::Tiny;

plan 5;

my SVG::Tiny $image;
my Str $expected;
my Str $output;

# 9.2 rect
$image .= new( viewbox=>'0 0 100 100' );
$image.rect( width=>12, height=>13, x=>10, y=>11, fill=>'maroon', ry=>5,
 stroke=>'fuchsia', rx=>6, stroke_width=>4 ); # all parameters in jumbled order
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<rect x="10" y="11" width="12" height="13" rx="6" ry="5" fill="maroon" stroke="fuchsia" stroke-width="4" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "rect with all parameters" );

$image .= new( viewbox=>'0 0 1200 400' );
$image.rect( width=>400, height=>200, x=>100, y=>100, fill=>'green', rx=>50 );
$image.g( transform=>'translate(700 210) rotate(-30)',
    $image.rect( width=>400, height=>200, x=>0, stroke=>'purple', y=>0, fill=>'none', rx=>50, stroke_width=>30 )
);
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 1200 400" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<rect x="100" y="100" width="400" height="200" rx="50" fill="green" />
<g transform="translate(700 210) rotate(-30)">
<rect x="0" y="0" width="400" height="200" rx="50" fill="none" stroke="purple" stroke-width="30" />
</g>
</svg>]; # almost the same as spec example 09_02.svg
$output = $image.svg;
eq_or_diff( $output, $expected, "rect rounded and transformed" );

# 9.3 circle
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
$image.ellipse( ry=>2, stroke_width=>3, fill=>'teal', cy=>4,
 stroke=>'navy', cx=>5, rx=>6 ); # all parameters in jumbled order
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<ellipse cx="5" cy="4" rx="6" ry="2" fill="teal" stroke="navy" stroke-width="3" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "ellipse with all parameters" );

# 9.5 line
$image .= new( viewbox=>'0 0 100 100' );
$image.line( x1=>4, y1=>5, x2=>6, y2=>7, stroke_width=>3,
 stroke=>'silver' );
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<line x1="4" y1="5" x2="6" y2="7" stroke_width="3" stroke="silver" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "line" );

=begin pod

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=end pod
