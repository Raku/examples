#!/usr/local/bin/perl6
use Test::Differences;
use Pod::to::xhtml;
use Test::Mock::Parser;

class Test::Parser is Pod::to::xhtml does Test::Mock::Parser {}

plan 8;

my Test::Parser $p .= new; $p.parse_file('/dev/null'); # warming up,
# initializes Parser state even though testing parses strings not files.

my $pod = slurp('t/p01-plain.pod').chomp; # Rakudo slurp appends a "\n"
my $expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <p>document 01 plain text</p>
</body>
</html>];
my $output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p01-plain.pod simplest text" );

$pod = slurp('t/p02-para.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <p>Document p02-para.pod tests paragraphs.</p>

    <p>After the above one liner, this second paragraph has three lines to
    verify that all lines are processed together as one paragraph, and to check
    word wrap.</p>

    <p>The third paragraph is declared in the abbreviated style.</p>

    <p>The fourth paragraph is declared in the delimited style.</p>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, 'p02-para.pod paragraphs' );

$pod = slurp('t/p03-head.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <h1>NAME</h1>

    <p>Pod::Parser - stream based parser for Perl 6 Plain Old Documentation</p>

    <h1>DESCRIPTION</h1>

    <h2>SPECIFICATION</h2>

    <p>The specification for Perl 6 POD is Synopsis 26, which can be found at
    http://perlcabal.org/syn/S26.html</p>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, 'p03-head.pod =head1 and =head2' );

$pod = slurp('t/p04-code.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <h1>NAME</h1>

    <p>p04-code.pod - test processing of code (verbatim) paragraph</p>

    <h1>SYNOPSIS</h1>
    <pre>

 # code, paragraph style
 say 'first';
    </pre>

    <p>This text is a non code paragraph.</p>
    <pre>

# code, delimited block style
say 'second';
    </pre>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, 'p04-code.pod code paragraphs' );

$pod = slurp('t/p05-pod5.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <p>The =pod is a Perl 5 POD command.</p>

    <h1>NAME</h1>

    <p>p05-pod5.pod - Perl 5 Plain Old Document to test backward compatibility
    </p>

    <h1>DESCRIPTION</h1>

    <p>This document starts with a marker that indicates POD 5 and not POD 6.
    </p>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, 'p05-pod5.pod legacy compatibility' );

$pod = slurp('t/p07-basis.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <p>Document p07-basis.pod tests the B formatting code. The B &lt; &gt;
    formatting code specifies that the contained text is the basis or focus of
    the surrounding text; that it is of fundamental significance. Such content
    would typically be rendered in a bold style or in &lt; strong &gt; ... &lt;
    /strong &gt; tags.</p>

    <p>One <strong>basis</strong> word.</p>

    <p>Then <strong>two basis</strong> words.</p>

    <p>Third, <strong>a basis phrase</strong> followed by <strong>another basis
    phrase</strong>.</p>

    <p>Fourth, <strong>a basis phrase that is so long that it should be word
    wrapped in whatever output format it is rendered</strong>.</p>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p07-basis.pod format B<basis>" );

$pod = slurp('t/p08-code.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <p>Document p08-code.pod tests the C formatting code. The C &lt; &gt;
    formatting code specifies that the contained text is code; that is,
    something that might appear in a program or specification. Such content
    would typically be rendered in a fixed-width font (preferably a different
    font from that used for the T &lt; &gt; or K &lt; &gt; formatting codes) or
    with  &lt; samp &gt; ... &lt; /samp &gt; tags. The contents of a C &lt;
    &gt; code are space-preserved and verbatim. The C &lt; &gt; code is the
    inline equivalent of the =code block.</p>

    <p>Preserve the punctuation and <code>say "---   ---";</code> three spaces.
    </p>

    <p>Also preserve <code>if $a &lt;  5 and $a &gt;  0 { say "yes"; }</code>
    markup characters.</p>

    <p>Multiple angles <code> $a = ( $b &gt; $c );</code> also delimit.</p>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, "p08-code.pod format C<code>" );

$pod = slurp('t/p13-link.pod').chomp; # Rakudo slurp appends a "\n"
$expected = q[<?xml version="1.0" ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>test</title>
<style type="text/css">
code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }
</style>
</head>
<body>

    <p>Document p13-link.pod tests the L formatting code. The L &lt; &gt; code
    is used to specify all kinds of links, filenames, citations, and
    cross-references (both internal and external).</p>

    <p>The simplest link is internal, such as to SCHEMES.</p>

    <p>A link may also specify an alternate name and a scheme.</p>

    <h1>SCHEMES</h1>

    <p>The following examples were taken from <a
    href="http://perlcabal.org/syn/S26.html">S26</a> and then extended.</p>

    <h2>http: and https:</h2>

    <p><a href="http://www.mp3dev.org/mp3/">http://www.mp3dev.org/mp3/</a> See
    also: <a href="tutorial/faq.html">tutorial/faq.html</a> and <a
    href="../examples/index.html">../examples/index.html</a></p>

    <h2>file:</h2>

    <p>Either <a
    href="file:///usr/local/lib/.configrc">/usr/local/lib/.configrc</a> or <a
    href="file://~/.configrc">~/.configrc</a>. Either <a
    href="file://.configrc">.configrc</a> or <a
    href="file://CONFIG/.configrc">CONFIG/.configrc</a>.</p>

    <h2>mailto:</h2>

    <p>Please forward bug reports to <a
    href="mailto:devnull@rt.cpan.org">devnull@rt.cpan.org</a></p>

    <h2>man:</h2>

    <p>Unix find(1) facilities.</p>

    <h2>doc:</h2>

    <p>You may wish to use <a
    href="http://perldoc.perl.org/Data/Dumper.html">Data::Dumper</a> to view
    the results. See also: <a
    href="http://perldoc.perl.org/perldata.html">perldata</a>.</p>

    <h2>defn:</h2>

    <p>prone to <a name="lexiphania"> lexiphania </a> : an unfortunate
    proclivity</p>

    <p>To treat his chronic <a href="#lexiphania">lexiphania</a> the doctor
    prescribed</p>

    <h2>isbn: and issn:</h2>

    <p>The Perl Journal ( 1087-903X).</p>
</body>
</html>];
$output = $p.parse( $pod ).join("\n");
eq_or_diff( $output, $expected, 'p13-link.pod format L<link>' );

