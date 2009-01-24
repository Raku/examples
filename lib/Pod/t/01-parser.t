#!/usr/local/bin/perl6
use Test;
use Pod::Parser;

plan 8;

# Note: the 'content ' and 'ambient ' lines always contain a space, and
# possibly other significant spaces, even at the end of the line.

# wrapper class for testing overrides file input and standard output
class Test::Parser is Pod::Parser {
    has @!out is rw;
    # parse source lines from a text document instead of a file
    method parse( $self: $text ) {
        my @lines = $text.split( "\n" );
        @!out = ();
        self.doc_beg( 'test' );
        for @lines -> $line { self.parse_line( $line ); }
        self.doc_end;
        return @!out;
    }
    # capture Pod6Parser output into array @.out for inspection
    method emit( $self: $text ) { push @!out, $text; }
    # Possible Rakudo bug: calling a base class method ignores other
    # overrides in derived class, such as the above emit() redefine.
    # workaround: redundantly copy base class method here, fails too!
}

my Test::Parser $p .= new; $p.parse_file('/dev/null'); # warming up

my Str $pod = slurp('t/p01-plain.pod').chomp; # Rakudo slurp appends a "\n"
my Str $expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg para PARAGRAPH
content document 01 plain text
blk end para PARAGRAPH
blk end pod DELIMITED
doc end";
my Str $output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p01-plain.pod simplest text' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p02-para.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg para PARAGRAPH
content Document p02-para.pod tests paragraphs.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content After the above one liner,
content this second paragraph has three lines to verify that all lines
content are processed together as one paragraph, and to check word wrap.
blk end para PARAGRAPH
blk beg para ABBREVIATED
content The third paragraph is declared in the abbreviated style.
blk end para ABBREVIATED
blk beg para DELIMITED
content The fourth paragraph is declared in the delimited style.
blk end para DELIMITED
blk end pod DELIMITED
doc end";
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p02-para.pod paragraphs' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p03-head.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg head POD_BLOCK level=>1
content NAME
blk end head POD_BLOCK
blk beg para PARAGRAPH
content Pod::Parser - stream based parser for Perl 6 Plain Old Documentation
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>1
content DESCRIPTION
blk end head POD_BLOCK
blk beg head POD_BLOCK level=>2
content SPECIFICATION
blk end head POD_BLOCK
blk beg para PARAGRAPH
content The specification for Perl 6 POD is Synopsis 26,
content which can be found at http://perlcabal.org/syn/S26.html
blk end para PARAGRAPH
blk end pod DELIMITED
doc end";
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p03-head.pod =head1 and =head2' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p04-code.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg head POD_BLOCK level=>1
content NAME
blk end head POD_BLOCK
blk beg para PARAGRAPH
content p04-code.pod - test processing of code (verbatim) paragraph
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>1
content SYNOPSIS
blk end head POD_BLOCK
blk beg code PARAGRAPH
content  # code, paragraph style
content  say 'first';
blk end code PARAGRAPH
blk beg para PARAGRAPH
content This text is a non code paragraph.
blk end para PARAGRAPH
blk beg code DELIMITED
content # code, delimited block style
content say 'second';
blk end code DELIMITED
blk end pod DELIMITED
doc end";
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p04-code.pod code paragraphs' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p05-pod5.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q(doc beg test
ambient #!/path/to/perl5
ambient 
ambient print "First Perl 5 statement\n";
ambient 
blk beg pod DELIMITED version=>5
blk beg para PARAGRAPH
content The =pod is a Perl 5 POD command.
blk end para PARAGRAPH
blk end pod DELIMITED
ambient 
ambient print "Second Perl 5 statement\n";
ambient print "Third Perl 5 statement\n";
ambient 
blk beg pod DELIMITED version=>5
blk beg head POD_BLOCK level=>1
content NAME
blk end head POD_BLOCK
blk beg para PARAGRAPH
content p05-pod5.pod - Perl 5 Plain Old Document to test backward compatibility
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>1
content DESCRIPTION
blk end head POD_BLOCK
blk beg para PARAGRAPH
content This document starts with a marker that indicates POD 5 and not POD 6.
blk end para PARAGRAPH
blk end pod DELIMITED
ambient 
doc end);
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p05-pod5.pod legacy compatibility' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p07-basis.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg para PARAGRAPH
content Document p07-basis.pod tests the B formatting code.
content The B < > formatting code specifies that the contained text is the basis
content or focus of the surrounding text; that it is of fundamental
content significance.
content Such content would typically be rendered in a bold style or in
content < strong > ... < /strong > tags.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content One 
fmt beg B<... angle_L=>< angle_R=>>
content basis
fmt end  B...>
content  word.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content Then 
fmt beg B<... angle_L=>< angle_R=>>
content two basis
fmt end  B...>
content  words.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content Third, 
fmt beg B<... angle_L=>< angle_R=>>
content a basis phrase
fmt end  B...>
content  followed by 
fmt beg B<... angle_L=>< angle_R=>>
content another basis phrase
fmt end  B...>
content .
blk end para PARAGRAPH
blk beg para PARAGRAPH
content Fourth, 
fmt beg B<... angle_L=>< angle_R=>>
content a basis phrase that is so long that it should be word wrapped
content in whatever output format it is rendered
fmt end  B...>
content .
blk end para PARAGRAPH
blk end pod DELIMITED
doc end";
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p07-basis.pod format B<basic>' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p08-code.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[doc beg test
blk beg pod DELIMITED version=>6
blk beg para PARAGRAPH
content Document p08-code.pod tests the C formatting code.
content The C < > formatting code specifies that the contained text is code;
content that is, something that might appear in a program or specification.
content Such content would typically be rendered in a fixed-width font
content (preferably a different font from that used for the T < > or K < >
content formatting codes) or with  < samp > ... < /samp > tags.
content The contents of a C < > code are space-preserved and verbatim.
content The C < > code is the inline equivalent of the =code block.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content Preserve the punctuation and 
fmt beg C<... angle_L=>< angle_R=>>
content say "---   ---";
fmt end  C...>
content  three spaces.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content Also preserve 
fmt beg C<... angle_L=>< angle_R=>>
content if $a <
content  5 and $a >
content  0 { say "yes"; }
fmt end  C...>
content  markup characters.
blk end para PARAGRAPH
blk beg para PARAGRAPH
content Multiple angles 
fmt beg C<... angle_L=><< angle_R=>>>
content  $a = ( $b > $c );
fmt end  C...>
content  also delimit.
blk end para PARAGRAPH
blk end pod DELIMITED
doc end];
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p08-code.pod format C<code>' );
#$*ERR.say: "OUTPUT: $output";

$pod = slurp('t/p13-link.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "doc beg test
blk beg pod DELIMITED version=>6
blk beg para PARAGRAPH
content Document p13-link.pod tests the L formatting code.
content The L < > code is used to specify all kinds of links, filenames,
content citations, and cross-references (both internal and external).
blk end para PARAGRAPH
blk beg para PARAGRAPH
content The simplest link is internal, such as to 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=> internal=>SCHEMES scheme=>doc
content #SCHEMES
fmt end  L...>
content .
blk end para PARAGRAPH
blk beg para PARAGRAPH
content A link may also specify an alternate name and a 
fmt beg L<... alternate=>scheme angle_L=>< angle_R=>> external=> internal=>SCHEMES scheme=>doc
content scheme|doc:#SCHEMES
fmt end  L...>
content .
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>1
content SCHEMES
blk end head POD_BLOCK
blk beg para PARAGRAPH
content The following examples were taken from 
fmt beg L<... alternate=>S26 angle_L=>< angle_R=>> external=>//perlcabal.org/syn/S26.html internal=> scheme=>http
content S26|http://perlcabal.org/syn/S26.html
fmt end  L...>
content  and
content then extended.
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content http: and https:
blk end head POD_BLOCK
blk beg para PARAGRAPH
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>//www.mp3dev.org/mp3/ internal=> scheme=>http
content http://www.mp3dev.org/mp3/
fmt end  L...>
content  See
content also: 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>tutorial/faq.html internal=> scheme=>http
content http:tutorial/faq.html
fmt end  L...>
content  and 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>../examples/index.html internal=> scheme=>http
content http:../examples/index.html
fmt end  L...>
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content file:
blk end head POD_BLOCK
blk beg para PARAGRAPH
content Either 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>/usr/local/lib/.configrc internal=> scheme=>file
content file:/usr/local/lib/.configrc
fmt end  L...>
content  or 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>~/.configrc internal=> scheme=>file
content file:~/.configrc
fmt end  L...>
content .
content Either 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>.configrc internal=> scheme=>file
content file:.configrc
fmt end  L...>
content  or 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>CONFIG/.configrc internal=> scheme=>file
content file:CONFIG/.configrc
fmt end  L...>
content .
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content mailto:
blk end head POD_BLOCK
blk beg para PARAGRAPH
content Please forward bug reports to 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>devnull@rt.cpan.org internal=> scheme=>mailto
content mailto:devnull@rt.cpan.org
fmt end  L...>
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content man:
blk end head POD_BLOCK
blk beg para PARAGRAPH
content Unix 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>find(1) internal=> scheme=>man
content man:find(1)
fmt end  L...>
content  facilities.
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content doc:
blk end head POD_BLOCK
blk beg para PARAGRAPH
content You may wish to use 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>Data::Dumper internal=> scheme=>doc
content doc:Data::Dumper
fmt end  L...>
content  to
content view the results. See also: 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>perldata internal=> scheme=>doc
content doc:perldata
fmt end  L...>
content .
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content defn:
blk end head POD_BLOCK
blk beg para PARAGRAPH
content prone to 
fmt beg D<... angle_L=>< angle_R=>>
content lexiphania
fmt end  D...>
content : an unfortunate proclivity
blk end para PARAGRAPH
blk beg para PARAGRAPH
content To treat his chronic 
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>lexiphania internal=> scheme=>defn
content defn:lexiphania
fmt end  L...>
content  the doctor prescribed
blk end para PARAGRAPH
blk beg head POD_BLOCK level=>2
content isbn: and issn:
blk end head POD_BLOCK
blk beg para PARAGRAPH
content The Perl Journal (
fmt beg L<... alternate=> angle_L=>< angle_R=>> external=>1087-903X internal=> scheme=>issn
content issn:1087-903X
fmt end  L...>
content ).
blk end para PARAGRAPH
blk end pod DELIMITED
doc end";
$output = $p.parse( $pod ).join("\n");
is( $output, $expected, 'p13-link.pod format L<link>' );
#$*ERR.say: "OUTPUT:\n$output";

