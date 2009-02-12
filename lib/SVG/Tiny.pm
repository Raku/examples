# Module SVG::Tiny

grammar SVG_Tiny {
    # elements and their allowed attributes
    regex g        { <id> | <xml__id> }
    regex path     { <d> | <stroke> | <stroke_width> }
    regex rect     { <x> | <y> | <width> | <height> | <rx> | <ry> | <fill> | <stroke> | <stroke_width> }
    regex circle   { <cx> | <cy> | <r> | <fill> | <stroke> | <stroke_width> }
    regex ellipse  { <cx> | <cy> | <rx> | <ry> | <fill> | <stroke> | <stroke_width> }
    regex line     { <x1> | <y1> | <x2> | <y2> | <stroke> | <stroke_width> }
    regex polyline { <points> | <stroke> | <stroke_width> }
    regex polygon  { <points> | <stroke> | <stroke_width> }
    # attributes
    regex d            { d      '="' .* '"' }
    regex x            { x      '="' <.digit>+ '"' }
    regex y            { y      '="' <.digit>+ '"' }
    regex width        { width  '="' <.digit>+ '"' }
    regex height       { height '="' <.digit>+ '"' }
    regex cx           { cx     '="' <.digit>+ '"' }
    regex cy           { cy     '="' <.digit>+ '"' }
    regex r            { r      '="' <.digit>+ '"' }
    regex rx           { rx     '="' <.digit>+ '"' }
    regex ry           { ry     '="' <.digit>+ '"' }
    regex x1           { x1     '="' <.digit>+ '"' }
    regex y1           { y1     '="' <.digit>+ '"' }
    regex x2           { x2     '="' <.digit>+ '"' }
    regex y2           { y2     '="' <.digit>+ '"' }
    regex fill         { fill   '="' [ <.color> | none ] '"' }
    regex stroke       { stroke '="' <.color>  '"' }
    regex stroke_width { stroke'-'width '="' <.digit>+ '"' }
    regex points       { points '="' <.point> [ <.ws> <.point> ]* '"' }
    # contents of attributes
    regex point  { <.digit>+ ',' <.digit>+ }
    regex color  { black | silver | gray | white | maroon | red | purple
        | fuchsia | green | lime | olive | yellow | navy | blue | teal |
        aqua | '#' <hexdigit>**3 | '#' <hexdigit>**6
    }
    regex hexdigit { <[0..9abcdefABCDEF]> }
}

class SVG::Tiny
{
    has $!viewbox;
    has $!namespace_prefix;
    has @!elements;
    my  @.paths is rw;

    method comment( Str $s ) { @!elements.push( "<!-- $s -->" ); }

    # 5.1 svg
    # Returns the entire SVG image as a Str.
    method svg {
        return join( "\n",
            "<?xml version=\"1.0\"?>",
            "<svg viewbox=\"$!viewbox\" xmlns=\"http://www.w3.org/2000/svg\""
                ~ " version=\"1.2\" baseProfile=\"tiny\">",
            @!elements,
            "</svg>"
        );
    }

    # 5.2 g
    # Groups the elements generated within its parameter list.
    # eg $image.g( $image.circle(...), $image.rect(...) );
    method g_new( *%params ) {
        self.element( 'g', %params, regex { <SVG_Tiny::g> } );
    }

    method g( :$id, :$xml__id, :$transform, *@subscripts ) {
        # the slurpy *@subscripts receives the element numbers returned
        # by the elements (rect(), circle(), even g() called in the
        # parameter list of this g() element.
        my $pid        = defined( $id ) ?? " id=\"$id\"" !! "";
        my $pxml_id    = defined( $xml__id ) ?? " xml:id=\"$xml__id\"" !! "";
        my $ptransform = defined( $transform ) ?? " transform=\"$transform\"" !! "";
        my Int $groupstart = int @!elements;
        if @subscripts {
            # need to insert a <g> before the elements that were
            # created in the parameter list to this g() method.
            $groupstart = @subscripts[0];
            # Rakudo r36322 has no splice (yet)
            # @!elements.splice( $groupstart, 0, "" );
            # Therefore this inferior workaround :(
            my $i = @!elements.end + 1;
            while $i > $groupstart {
                @!elements[$i] = @!elements[--$i];
            }
        }
        @!elements[$groupstart] = "<g$pid$pxml_id$ptransform>";
        @!elements.push( "</g>" );
        return $groupstart .. + @!elements.end;
    }

    # 8.2 path
    method path( *%params ) {
        self.element( 'path', %params, regex { <SVG_Tiny::path> } ); }
    # In order to have more compact programs without needing to
    # repetitively state the image object name, the following functions
    # for section 8 are implemented as subs outside class SVG::Tiny.
    # For example,
    #   $image.path( d=>pathdata( moveto(10,10), lineto(10,20) ) );
    # instead of,
    #   $image.path( d=>$image.pathdata( $image.moveto(10,10), $image.lineto(10,20) ) );

    # 9.2 rect
    method rect( *%params ) {
        self.element( 'rect', %params, regex { <SVG_Tiny::rect> } ); }

    # 9.3 circle
    method circle( *%params ) {
        self.element( 'circle', %params, regex { <SVG_Tiny::circle> } ); }

    # 9.4 ellipse
    method ellipse( *%params ) {
        self.element( 'ellipse', %params, regex { <SVG_Tiny::ellipse> } ); }

    # 9.5 line
    method line( *%params ) {
        self.element( 'line', %params, regex { <SVG_Tiny::line> } ); }

    # 9.6 polyline
    method polyline( *%params ) {
        self.element( 'polyline', %params, regex { <SVG_Tiny::polyline> } ); }

    # 9.7 polygon
    method polygon( *%params ) {
        self.element( 'polygon', %params, regex { <SVG_Tiny::polygon> } ); }

    submethod element( Str $element is copy, %parameters, $regex )
    {
        my @attributes;
        my @warnings;
        for %parameters.kv -> $key is copy, $value {
            # mangle names containing certain awkward characters,
            # a blemish in an otherwise nice design
            $key .= subst( '__', ':' ); # eg xml__id -> xml:id
            $key .= subst( '_', '-' ); # eg stroke_width -> stroke-width
            # format the attribute how it must look in the SVG document
            my $attribute = qq[$key="$value"];
            if $attribute ~~ $regex { @attributes.push( $attribute ); }
            else                    { @warnings.push(   $attribute ); }
        }
        if @attributes { @attributes[@attributes.end] ~= ' '; }
        @!elements.push( "<$element {@attributes}/>" );
        if @warnings {
            @!elements[*-1] ~= "<!-- invalid {@warnings} -->";
        }
        @!elements.end;
    }

    method pushpath( $s ) { @.paths.push( $s ); }
}

# 8.3 pathdata
sub pathdata( *@params ) {
    # TODO: minimize the path data in all the ways listed in 8.3.1.
    my $pathdata = SVG::Tiny.paths.join(' ');
    SVG::Tiny.paths = ();
    return $pathdata;
}
# 8.3.2 moveto
sub moveto( :$x, :$y, :$abs, :$rel ) {
    SVG::Tiny.pushpath( "M$x,$y" );
}
# 8.3.3 closepath
sub closepath { SVG::Tiny.pushpath( 'z' ); }

# 8.3.4 lineto
sub lineto( :$x, :$y ) { SVG::Tiny.pushpath( "L$x,$y"); }

# 8.3.6 cubic Bezier curves
sub curveto( :$x1, :$y1, :$x2, :$y2, :$x, :$y, :$abs, :$rel ) {
    SVG::Tiny.pushpath( "C$x1,$y1 $x2,$y2 $x,$y"); }
sub smooth_curveto( :$x2, :$y2, :$x, :$y, :$abs, :$rel ) {
    SVG::Tiny.pushpath( "S$x2,$y2 $x,$y"); }

# 8.3.7 quadratic Bezier curves
# The names are long, but this is what the spec calls them.
sub quadratic_bezier_curveto( :$x1, :$y1, :$x, :$y, :$abs, :$rel ) {
    SVG::Tiny.pushpath( "Q$x1,$y1 $x,$y"); }
sub smooth_quadratic_bezier_curveto( :$x, :$y, :$abs, :$rel ) {
    SVG::Tiny.pushpath( "T$x,$y"); }
    
=begin pod

=head1 NAME
SVG::Tiny - Scalable Vector Graphics Tiny class

=head1 SYNOPSIS
=begin code
use SVG::Tiny;
my SVG::Tiny $image .= new( viewbox=>'0 0 100 100' );
$image.rect( x=>10, y=>10, width=>10, height=>10, fill=>'red' );
print $image.svg;
=end code

=head1 DESCRIPTION
SVG Tiny is a compact yet functional subset of Scalar Vector Graphics
for use in low memory browsers, for example in mobile telephones.
Do not be fooled by the name. SVG-Tiny covers most normal images.

This SVG::Tiny class creates images as strings in SVG format, without
pretty printing.

=head1 METHODS
=head2 svg()
=head2 g( id, xml_id, transform, fill )
=head2 path( pathdata, stroke, stroke_width )
=head2 moveto( x, y, rel, abs )
=head2 closepath()
=head2 lineto( x, y, rel, abs )
=head2 curveto( x1, y1, x2, y2, x, y, rel, abs )
=head2 smooth_curveto( x1, y1, x2, y2, x, y, rel, abs )
=head2 quadratic_bezier_curveto( x1, y1, x, y, rel, abs )
=head2 smooth_quadratic_bezier_curveto( x, y, rel, abs )
=head2 rect( x, y, width, height, fill, stroke, stroke_width )
=head2 circle( cx, cy, r, fill, stroke, stroke_width )
=head2 ellipse( cx, cy, rx, ry, Str fill, stroke, stroke_width )
=head2 line( x1, y1, x2, y2, stroke, stroke_width )
=head2 polyline( points, stroke, stroke_width )
=head2 polygon( points, stroke, stroke_width )

=head1 TESTING
The W3C has test suites for SVG 1.1 and SVG Tiny 1.2, consisting of
hundreds of SVG documents accompanied by PNG files depicting how each
one should look when rendered by a user agent such as a web browser.
A typical current browser such as Firefox 3.0.6 fails many of the tests.
The volume and complexity of the tests is too much to be practical for
testing a module whose job is merely to emit valid SVG.
A small representative sampling will be taken to test whether the
document structures can be generated.

The SVG-Tiny-1.2 specification contains many compact examples of correct
usage, with distinct and mostly meaningful file names.

Lacking another practical approach, and aware that full coverage is
overly ambitious, the testing plan will aim to use Perl 6 test cases to
generate near equivalents of as many of the spec examples as possible.
Near equivalents will mean elements and attributes must match, but
newlines and blanks may differ.
A plainformat() routine will reduce each element to a single line, with
attributes in alpabetical order, single spaced and without indentation.

Copies of the unaltered example files are therefore kept in the SVG/t/
directory.

If you can think of a more effective testing strategy, particularly one
that saves time and space whilst equalling or improving thoroughness,
please let the author know.

The current test suite covers 0 of 1 (0%) of the examples.

=head1 TODO
Add missing functionality. Generate transform and path attributes in
code. Improve testing coverage.

=head1 BUGS
Named parameters cannot be typed.

Changes to Parrot or Rakudo might expose errors in this module.
It passed 14/14 tests on 2009-02-12 with r36634.

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @flashmail.com).

=end pod

