# Module SVG::Tiny

grammar SVG_Tiny {
    # elements and their allowed attributes
    regex path     { <d> | <stroke> | <stroke_width> }
    regex line     { <x1> | <y1> |<x2> | <y2> | <stroke> | <stroke_width> }
    regex polyline { <points> | <stroke> | <stroke_width> }
    regex polygon  { <points> | <stroke> | <stroke_width> }
    # attributes
    regex d            { d      '="' .* '"' }
    regex x1           { x1     '="' <.digit>+ '"' }
    regex y1           { y1     '="' <.digit>+ '"' }
    regex x2           { x2     '="' <.digit>+ '"' }
    regex y2           { y2     '="' <.digit>+ '"' }
    regex fill         { fill   '="' <.color> '"' }
    regex stroke       { stroke '="' <.color> '"' }
    regex stroke_width { stroke'-'width '="' <.digit>+ '"' }
    regex points       { points '="' <.point> [ <.ws> <.point> ]* '"' }
    # contents of attributes
    regex point  { <.digit>+ ',' <.digit>+ }
    regex color  { black | silver | gray | white | maroon | red | purple
        fuchsia | green | lime | olive | yellow | navy | blue | teal |
        aqua }
}

class SVG::Tiny
{
    has $!viewbox;
    has $!namespace_prefix;
    has @!elements;
    my  @.paths is rw;

    method comment( Str $comment ) {
        @!elements.push( "<!-- $comment -->" );
    }

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
    method g( :$id, :$xml_id, :$transform, *@subscripts ) {
        # the slurpy *@subscripts receives the element numbers returned
        # by the elements (rect(), circle(), even g() called in the
        # parameter list of this g() element.
        my $pid        = defined( $id ) ?? " id=\"$id\"" !! "";
        my $pxml_id    = defined( $xml_id ) ?? " xml:id=\"$xml_id\"" !! "";
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
    method path( *%params )
    {
        self.element( 'path', %params, regex { <SVG_Tiny::path> } );
        return @!elements.end;
    }
    # In order to be able to write more compact programs without having
    # to repetitively state the image object name, the other functions
    # for section 8 are implemented as exported subs below (and outside)
    # class SVG_Tiny.
    # for example,
    # $image.path( d=>pathdata( moveto(10,10), lineto(10,20) ) );
    # instead of,
    # $image.path( d=>$image.pathdata( $image.moveto(10,10), $image.lineto(10,20) ) );

    # 8.3.6 curveto smooth_curveto
    method curveto( ) {
    }
    method smooth_curveto( ) {
    }
    # 8.3.7 qcurveto sqcurveto
    method qcurveto( ) {
    }
    method qscurveto( ) {
    }
    

    # 9.2 rect
    method rect( :$x, :$y, :$width, :$height, :$rx, :$ry,
                 :$fill, :$stroke, :$stroke_width )
                 # Sorry, untyped because types on optional parameters
                 # cause errors when the parameter is omitted.
                 # Noted in BUGS below.
    {
        # This style just cries out for some meta-programming shorthand
        # to eliminate repetition. But how, and isn't inlining like this
        # the most efficient? Maybe wait until Rakudo gets macros...
        my $px            = defined( $x ) ??
                            "x=\"$x\" " !! "";
        my $py            = defined( $y ) ??
                            "y=\"$y\" " !! "";
        my $pwidth        = defined( $width ) ??
                            "width=\"$width\" " !! "";
        my $pheight       = defined( $height ) ??
                            "height=\"$height\" " !! "";
        my $prx           = defined( $rx ) ??
                            "rx=\"$rx\" " !! "";
        my $pry           = defined( $ry ) ??
                            "ry=\"$ry\" " !! "";
        my $pfill         = defined( $fill ) ??
                            "fill=\"$fill\" " !! "";
        my $pstroke       = defined( $stroke ) ??
                            "stroke=\"$stroke\" " !! "";
        my $pstroke_width = defined( $stroke_width ) ??
                            "stroke-width=\"$stroke_width\" " !! "";
        @!elements.push( "<rect $px$py$pwidth$pheight$prx$pry$pfill$pstroke$pstroke_width/>" );
        return @!elements.end;
    }

    # 9.3 circle
    method circle( :$cx, :$cy, :$r,
                   :$fill, :$stroke, :$stroke_width )
    {
        my $pcx           = defined( $cx ) ??
                            "x=\"$cx\" " !! "";
        my $pcy           = defined( $cy ) ??
                            "y=\"$cy\" " !! "";
        my $pr            = defined( $r ) ??
                            "width=\"$r\" " !! "";
        my $pfill         = defined( $fill ) ??
                            "fill=\"$fill\" " !! "";
        my $pstroke       = defined( $stroke ) ??
                            "stroke=\"$stroke\" " !! "";
        my $pstroke_width = defined( $stroke_width ) ??
                            "stroke-width=\"$stroke_width\" " !! "";
        @!elements.push( "<circle $pcx$pcy$pr$pfill$pstroke$pstroke_width/>" );
        return @!elements.end;
    }

    # 9.4 ellipse
    method ellipse(  :$cx, :$cy, :$rx, :$ry,
                     :$fill, :$stroke, :$stroke_width )
    {
        my $pcx           = defined( $cx ) ??
                            "cx=\"$cx\" " !! "";
        my $pcy           = defined( $cy ) ??
                            "cy=\"$cy\" " !! "";
        my $prx           = defined( $rx ) ??
                            "rx=\"$rx\" " !! "";
        my $pry           = defined( $ry ) ??
                            "ry=\"$ry\" " !! "";
        my $pfill         = defined( $fill ) ??
                            "fill=\"$fill\" " !! "";
        my $pstroke       = defined( $stroke ) ??
                            "stroke=\"$stroke\" " !! "";
        my $pstroke_width = defined( $stroke_width ) ??
                            "stroke-width=\"$stroke_width\" "   !! "";
        @!elements.push( "<ellipse $pcx$pcy$prx$pry$pfill$pstroke$pstroke_width/>" );
        return @!elements.end;
    }

    # 9.5 line
    method line( *%params )
    {
        self.element( 'line', %params, regex { <SVG_Tiny::line> } );
        return @!elements.end;
    }

    # 9.6 polyline
    method polyline( *%params )
    {
        self.element( 'polyline', %params, regex { <SVG_Tiny::polyline> } );
        return @!elements.end;
    }

    # 9.7 polygon
    method polygon( *%params )
    {
        self.element( 'polygon', %params, regex { <SVG_Tiny::polygon> } );
        return @!elements.end;
    }

    submethod element( Str $element is copy, %parameters, $regex )
    {
        my @attributes;
        for %parameters.kv -> $key is copy, $value {
            # mangle names containing certain awkward characters
            # a little wrinkle in an otherwise elegant design
            $key .= subst( '__', ':' ); # eg xml__id -> xml:id
            $key .= subst( '_', '-' ); # eg stroke_width -> stroke-width
            # format the attribute how it must look in the SVG document
            my $attribute = qq[$key="$value"];
            if $attribute ~~ $regex { @attributes.push( $attribute ); }
            else {
                # TODO: give a helpful diagnostic but keep going
            }
        }
        if @attributes { @attributes[@attributes.end] ~= ' '; }
                         # need just one more space
        @!elements.push( "<$element {@attributes}/>" );
    }
    method pushpath( $s ) { @.paths.push( $s ); }
}

# 8.3 pathdata
sub pathdata( *@params ) {
    # TODO: minimize the path data in all the ways listed in 8.3.1.
    return SVG::Tiny.paths.join(' ');
}
# 8.3.2 moveto
sub moveto( :$x, :$y, :$abs, :$rel ) {
    SVG::Tiny.pushpath( "M$x $y" );
}
# 8.3.3 closepath
sub closepath {
    SVG::Tiny.pushpath( 'z' );
}
# 8.3.4 lineto
sub lineto( :$x, :$y ) { SVG::Tiny.pushpath( "L$x $y"); }

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
=head2 rect( x, y, width, height, fill, stroke, stroke_width )
=head2 circle( cx, cy, r, fill, stroke, stroke_width )
=head2 ellipse( cx, cy, rx, ry, Str fill, stroke, stroke_width )

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

The present code passes 10 tests and covers 0 of 1 (0%) of the examples.

=head1 TODO
Add missing functionality. Generate transform and path attributes in
code. Improve testing coverage.

=head1 BUGS
Named parameters cannot be typed.

Changes to Parrot or Rakudo might expose errors in this module.
All tests passed on 2009-02-09 with r36486.

=head1 SEE ALSO
L<http://www.w3.org/TR/SVGTiny12/>

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @flashmail.com).

=end pod

