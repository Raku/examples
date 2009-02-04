# 01-svg.t - SVG-Tiny-1.2 section 5 - Document Structure

use Test::Differences;
use SVG::Tiny;

plan 3;

my SVG::Tiny $image;
my Str $expected;
my Str $output;

# 5.1 svg
$image .= new( viewbox=>'0 0 100 100' );
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "empty svg" );

# 5.2 g
# empty group
$image .= new( viewbox=>'0 0 100 100' );
$image.g();
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<g>
</g>
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "empty group" );
# nested and named groups
$image .= new( viewbox=>'0 0 100 100' );
$image.g( id=>'first',
    $image.g( xml_id=>'second', $image.g( id=>'third' ) ),
    $image.g( xml_id=>'fourth')
);
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<g id="first">
<g xml:id="second">
<g id="third">
</g>
</g>
<g xml:id="fourth">
</g>
</g>
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "empty group" );

=begin pod

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=end pod
