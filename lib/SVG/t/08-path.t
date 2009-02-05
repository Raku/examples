# 08-path.t - SVG-Tiny-1.2 section 8 - Paths

use Test::Differences;
use SVG::Tiny;

plan 2;

my SVG::Tiny $image;
my Str $expected;
my Str $output;

# 8.2 path
$image .= new( viewbox=>'0 0 100 100' );
$image.path();
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<path />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "empty path" );

$image .= new( viewbox=>'0 0 100 100' );
$image.path( d=>'M 100 100 L 300 100 L 200 300 z', stroke=>'aqua' );
$expected = q[<?xml version="1.0"?>
<svg viewbox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.2" baseProfile="tiny">
<path d="M 100 100 L 300 100 L 200 300 z" stroke="aqua" />
</svg>];
$output = $image.svg;
eq_or_diff( $output, $expected, "path with d stroke stroke-width" );

