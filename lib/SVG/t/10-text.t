# 10-text.t - SVG-Tiny-1.2 section 10 - Text

use Test::Differences;
use SVG::Tiny;

plan 0;

my SVG::Tiny $image;
my Str       $expected;
my Str       $output;

# 10.4 text
$image .= new( viewbox=>'0 0 1000 300', width=>'10cm', height=>'3cm' );
# WARNING - FAULTY - UNDER CONSTRUCTION
#$image.text( x=>250, y=>150, font_family=>'Verdana', font_size=>55,
#    fill=>'blue',
#    'Hello, out there'
#);
$expected = q[<?xml version="1.0"?>
<svg baseProfile="tiny" height="3cm" version="1.2" viewBox="0 0 1000 300" width="10cm" xmlns="http://www.w3.org/2000/svg">
<text x="250" y="150" font-family="Verdana" font-size="55" fill="blue">Hello, out there</text>
</svg>];
$output = $image.svg;
# eq_or_diff( $output, $expected, "text element" );

=begin pod

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=end pod
