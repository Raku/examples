#!/usr/local/bin/perl6
use Test::Differences;
use Pod::to::text;

class TestParser is Pod::to::text {
    has @!out;
    # parse source lines from a text document instead of a file
    method parse( $self: $text ) {
        @!out = (); # clear content from any previous test
        self.doc_beg( 'test' );
        for $text.split( "\n" ) -> $line { $!line = $line; self.parse_line; }
        self.doc_end;
        return @!out;
    }
    # capture Pod6Parser output into array @.out for inspection
    method emit( Str $text ) { push @!out, $text; }
    # Possible Rakudo bug: calling a base class method ignores other
    # overrides in derived class, such as the above emit() redefine.
    # workaround: redundantly copy base class method here, fails too!
}

plan 8;

my TestParser $p .= new; $p.parse_file( '/dev/null' ); # warming up

my Str $pod = slurp('t/p01-plain.pod').chomp; # Rakudo slurp appends a "\n"
my Str $expected = "    document 01 plain text";
my Str $output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p01-plain.pod simplest text" );

$pod = slurp('t/p02-para.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "    Document p02-para.pod tests paragraphs.

    After the above one liner, this second paragraph has three lines to verify
    that all lines are processed together as one paragraph, and to check word
    wrap.

    The third paragraph is declared in the abbreviated style.

    The fourth paragraph is declared in the delimited style.";
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p02-para.pod paragraphs" );

$pod = slurp('t/p03-head.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "NAME
    Pod::Parser - stream based parser for Perl 6 Plain Old Documentation

DESCRIPTION
  SPECIFICATION
    The specification for Perl 6 POD is Synopsis 26, which can be found at
    http://perlcabal.org/syn/S26.html";
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, 'p03-head.pod =head1 and =head2' );

$pod = slurp('t/p04-code.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "NAME
    p04-code.pod - test processing of code (verbatim) paragraph

SYNOPSIS
     # code, paragraph style
     say 'first';

    This text is a non code paragraph.

    # code, delimited block style
    say 'second';";
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p04-code.pod code paragraphs" );

$pod = slurp('t/p05-pod5.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "    The =pod is a Perl 5 POD command.

NAME
    p05-pod5.pod - Perl 5 Plain Old Document to test backward compatibility

DESCRIPTION
    This document starts with a marker that indicates POD 5 and not POD 6.";
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p05-pod5.pod legacy compatibility" );

$pod = slurp('t/p07-basis.pod').chomp; # Rakudo slurp appends a "\n"
$expected = "    Document p07-basis.pod tests the B formatting code. The B < > formatting
    code specifies that the contained text is the basis or focus of the
    surrounding text; that it is of fundamental significance. Such content
    would typically be rendered in a bold style or in < strong > ... < /strong
    > tags.

    One basis word.

    Then two basis words.

    Third, a basis phrase followed by another basis phrase.

    Fourth, a basis phrase that is so long that it should be word wrapped in
    whatever output format it is rendered.";
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p07-basis.pod format B<basis>" );

$pod = slurp('t/p08-code.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[    Document p08-code.pod tests the C formatting code. The C < > formatting
    code specifies that the contained text is code; that is, something that
    might appear in a program or specification. Such content would typically be
    rendered in a fixed-width font (preferably a different font from that used
    for the T < > or K < > formatting codes) or with  < samp > ... < /samp >
    tags. The contents of a C < > code are space-preserved and verbatim. The C
    < > code is the inline equivalent of the =code block.

    Preserve the punctuation and "say "---   ---";" three spaces.

    Also preserve "if $a <  5 and $a >  0 { say "yes"; }" markup characters.

    Multiple angles " $a = ( $b > $c );" also delimit.];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p08-code.pod format C<code>" );

$pod = slurp('t/p13-link.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[    Document p13-link.pod tests the L formatting code. The L < > code is used
    to specify all kinds of links, filenames, citations, and cross-references
    (both internal and external).

    The simplest link is internal, such as to SCHEMES.

    A link may also specify an alternate name and a scheme.

SCHEMES
    The following examples were taken from S26 and then extended.

  http: and https:
    http://www.mp3dev.org/mp3/ See also: http:tutorial/faq.html and 
    http:../examples/index.html

  file:
    Either /usr/local/lib/.configrc or ~/.configrc. Either .configrc or 
    CONFIG/.configrc.

  mailto:
    Please forward bug reports to devnull@rt.cpan.org

  man:
    Unix find(1) facilities.

  doc:
    You may wish to use Data::Dumper to view the results. See also: perldata.

  defn:
    prone to lexiphania: an unfortunate proclivity

    To treat his chronic lexiphania the doctor prescribed

  isbn: and issn:
    The Perl Journal (1087-903X).];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p13-link.pod format L<link>" );

