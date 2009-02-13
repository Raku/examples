# 05-doc.t - SVG-Tiny-1.2 section 5 - Document Structure

use Test::Differences;
use SVG::Tiny;

plan 4;

my SVG::Tiny $image;
my Str       $expected;
my Str       $output;

# 5.1 svg
# comment
$image .= new( viewbox=>'0 0 100 100' );
$image.comment( 'comment test' );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<!-- comment test -->
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "comment" );

# 5.2 g
# empty group
$image .= new( viewbox=>'0 0 100 100' );
$image.g();
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<g>
</g>
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "empty group" );

# nested and named groups
$image .= new( viewbox=>'0 0 100 100' );
$image.g( id=>'first',
    $image.g( xml__id=>'second', $image.g( id=>'third' ) ),
    $image.g( xml__id=>'fourth')
);
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
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
eq_or_diff( $output, $expected, "nested and named groups" );

# 5.5 desc
$image .= new( viewbox=>'0 0 100 100' );
$image.desc( 'Description test' );
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" version="1.2" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<desc>Description test</desc>
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "comment" );

=begin pod

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=end pod
