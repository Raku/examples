#!/usr/local/bin/perl6
use Test::Differences;
use Pod::to::pod5;
use Pod::to::pod6;
use Test::Mock::Parser;

# This scripts checks bidirectional pod5 <--> pod6 conversion.
# The test suite intentionally contains only one file in pod5 format.
# The remaining pod5 source is all within this set of tests.

# wrapper class for testing overrides file input and standard output
class P5 is Pod::to::pod5 does Test::Mock::Parser {}
class P6 is Pod::to::pod6 does Test::Mock::Parser {}

plan 15; # test 'p04-code.pod code paragraphs 5->6' temporarily skipped

my P5 $p5 .= new; $p5.parse_file('/dev/null'); # warming up
my P6 $p6 .= new; $p6.parse_file('/dev/null'); # warming up,
# initializes Parser state even though testing parses strings not files.

my $pod6 = slurp('t/p01-plain.pod').chomp; # Rakudo slurp appends a "\n"
my $pod5 = q[=pod

document 01 plain text

=cut];
my $output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, "p01-plain.pod simplest text 6->5" );

$pod6 = q[=begin pod
=begin para
document 01 plain text
=end para
=end pod];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, "p01-plain.pod simplest text 5->6" );

$pod6   = slurp('t/p02-para.pod').chomp; # Rakudo slurp appends a "\n"
$pod5   = q[=pod

Document p02-para.pod tests paragraphs.

After the above one liner, this second paragraph has three lines to
verify that all lines are processed together as one paragraph, and to
check word wrap.

The third paragraph is declared in the abbreviated style.

The fourth paragraph is declared in the delimited style.

=cut];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p02-para.pod paragraphs 6->5' );

$pod6 = q[=begin pod
=begin para
Document p02-para.pod tests paragraphs.
=end para
=begin para
After the above one liner, this second paragraph has three lines to
verify that all lines are processed together as one paragraph, and to
check word wrap.
=end para
=begin para
The third paragraph is declared in the abbreviated style.
=end para
=begin para
The fourth paragraph is declared in the delimited style.
=end para
=end pod];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, 'p02-para.pod paragraphs 5->6' );

$pod6 = slurp('t/p03-head.pod').chomp; # Rakudo slurp appends a "\n"
$pod5 = q[=pod

=head1 NAME

Pod::Parser - stream based parser for Perl 6 Plain Old Documentation

=head1 DESCRIPTION

=head2 SPECIFICATION

The specification for Perl 6 POD is Synopsis 26, which can be found at
http://perlcabal.org/syn/S26.html

=cut];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p03-head.pod =head1 and =head2 6->5' );

$pod6 = q[=begin pod
=head1 NAME
=begin para
Pod::Parser - stream based parser for Perl 6 Plain Old Documentation
=end para
=head1 DESCRIPTION
=head2 SPECIFICATION
=begin para
The specification for Perl 6 POD is Synopsis 26, which can be found at
http://perlcabal.org/syn/S26.html
=end para
=end pod];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, 'p03-head.pod =head1 and =head2 5->6' );

$pod6 = slurp('t/p04-code.pod').chomp; # Rakudo slurp appends a "\n"
$pod5 = q[=pod

=head1 NAME

p04-code.pod - test processing of code (verbatim) paragraph

=head1 SYNOPSIS

  # code, paragraph style
  say 'first';

This text is a non code paragraph.

 # code, delimited block style
 say 'second';

=cut];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p04-code.pod code paragraphs 6->5' );

$pod6 = q[=begin pod
=head1 NAME
=begin para
p04-code.pod - test processing of code (verbatim) paragraph
=end para
=head1 SYNOPSIS
=begin code
  # code, paragraph style
  say 'first';
=end code
=begin para
This text is a non code paragraph.
=end para
=begin code
 # code, delimited block style
 say 'second';
=end code
=end pod];
#$output = $p6.parse( $pod5 ).join("\n");
#eq_or_diff( $output, $pod6, 'p04-code.pod code paragraphs 5->6' );

$pod6 = slurp('t/p05-pod5.pod').chomp; # Rakudo slurp appends a "\n"
$pod5 = q[#!/path/to/perl5

print "First Perl 5 statement\n";

=pod

The =pod is a Perl 5 POD command.

=cut

print "Second Perl 5 statement\n";
print "Third Perl 5 statement\n";

=pod

=head1 NAME

p05-pod5.pod - Perl 5 Plain Old Document to test backward compatibility

=head1 DESCRIPTION

This document starts with a marker that indicates POD 5 and not POD 6.

=cut
];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p05-pod5.pod legacy compatibility 5->5' );

$pod6 = q[#!/path/to/perl5

print "First Perl 5 statement\n";

=begin pod
=begin para
The =pod is a Perl 5 POD command.
=end para
=end pod

print "Second Perl 5 statement\n";
print "Third Perl 5 statement\n";

=begin pod
=head1 NAME
=begin para
p05-pod5.pod - Perl 5 Plain Old Document to test backward compatibility
=end para
=head1 DESCRIPTION
=begin para
This document starts with a marker that indicates POD 5 and not POD 6.
=end para
=end pod
];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, 'p05-pod5.pod legacy compatibility 5->6' );

$pod6 = slurp('t/p07-basis.pod').chomp; # Rakudo slurp appends a "\n"
$pod5 = q[=pod

Document p07-basis.pod tests the B formatting code. The B < > formatting
code specifies that the contained text is the basis or focus of the
surrounding text; that it is of fundamental significance. Such content
would typically be rendered in a bold style or in < strong > ... <
/strong > tags.

One B<basis> word.

Then B<two basis> words.

Third, B<a basis phrase> followed by B<another basis phrase>.

Fourth, B<a basis phrase that is so long that it should be word wrapped
in whatever output format it is rendered>.

=cut];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p07-basis.pod format B<basis> 6->5' );

$pod6 = q[=begin pod
=begin para
Document p07-basis.pod tests the B formatting code. The B < > formatting
code specifies that the contained text is the basis or focus of the
surrounding text; that it is of fundamental significance. Such content
would typically be rendered in a bold style or in < strong > ... <
/strong > tags.
=end para
=begin para
One B<basis> word.
=end para
=begin para
Then B<two basis> words.
=end para
=begin para
Third, B<a basis phrase> followed by B<another basis phrase>.
=end para
=begin para
Fourth, B<a basis phrase that is so long that it should be word wrapped
in whatever output format it is rendered>.
=end para
=end pod];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, 'p07-basis.pod format B<basis> 5->6' );

$pod6 = slurp('t/p08-code.pod').chomp; # Rakudo slurp appends a "\n"
$pod5 = q[=pod

Document p08-code.pod tests the C formatting code. The C < > formatting
code specifies that the contained text is code; that is, something that
might appear in a program or specification. Such content would typically
be rendered in a fixed-width font (preferably a different font from that
used for the T < > or K < > formatting codes) or with  < samp > ... <
/samp > tags. The contents of a C < > code are space-preserved and
verbatim. The C < > code is the inline equivalent of the =code block.

Preserve the punctuation and C<say "---   ---";> three spaces.

Also preserve C<if $a <  5 and $a >  0 { say "yes"; }> markup
characters.

Multiple angles C< $a = ( $b > $c );> also delimit.

=cut];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p08-code.pod format C<code> 6->5' );

$pod6 = q[=begin pod
=begin para
Document p08-code.pod tests the C formatting code. The C < > formatting
code specifies that the contained text is code; that is, something that
might appear in a program or specification. Such content would typically
be rendered in a fixed-width font (preferably a different font from that
used for the T < > or K < > formatting codes) or with  < samp > ... <
/samp > tags. The contents of a C < > code are space-preserved and
verbatim. The C < > code is the inline equivalent of the =code block.
=end para
=begin para
Preserve the punctuation and C<say "---   ---";> three spaces.
=end para
=begin para
Also preserve C<if $a <  5 and $a >  0 { say "yes"; }> markup
characters.
=end para
=begin para
Multiple angles C< $a = ( $b > $c );> also delimit.
=end para
=end pod];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, 'p08-code.pod format C<code> 5->6' );

$pod6 = slurp('t/p13-link.pod').chomp; # Rakudo slurp appends a "\n"
$pod5 = q[=pod

Document p13-link.pod tests the L formatting code. The L < > code is
used to specify all kinds of links, filenames, citations, and
cross-references (both internal and external).

The simplest link is internal, such as to L<#SCHEMES>.

A link may also specify an alternate name and a L<scheme|doc:#SCHEMES>.

=head1 SCHEMES

The following examples were taken from L<
S26|http://perlcabal.org/syn/S26.html> and then extended.

=head2 http: and https:

L<http://www.mp3dev.org/mp3/> See also: L<http:tutorial/faq.html> and L<
http:../examples/index.html>

=head2 file:

Either L<file:/usr/local/lib/.configrc> or L<file:~/.configrc>. Either 
L<file:.configrc> or L<file:CONFIG/.configrc>.

=head2 mailto:

Please forward bug reports to L<mailto:devnull@rt.cpan.org>

=head2 man:

Unix L<man:find(1)> facilities.

=head2 doc:

You may wish to use L<doc:Data::Dumper> to view the results. See also: 
L<doc:perldata>.

=head2 defn:

prone to lexiphania : an unfortunate proclivity

To treat his chronic L<defn:lexiphania> the doctor prescribed

=head2 isbn: and issn:

The Perl Journal ( L<issn:1087-903X>).

=cut];
$output = $p5.parse( $pod6 ).join("\n");
eq_or_diff( $output, $pod5, 'p13-link.pod format L<link> 6->5' );

$pod6 = q[=begin pod
=begin para
Document p13-link.pod tests the L formatting code. The L < > code is
used to specify all kinds of links, filenames, citations, and
cross-references (both internal and external).
=end para
=begin para
The simplest link is internal, such as to L<#SCHEMES>.
=end para
=begin para
A link may also specify an alternate name and a L<scheme|doc:#SCHEMES>.
=end para
=head1 SCHEMES
=begin para
The following examples were taken from L<
S26|http://perlcabal.org/syn/S26.html> and then extended.
=end para
=head2 http: and https:
=begin para
L<http://www.mp3dev.org/mp3/> See also: L<http:tutorial/faq.html> and L<
http:../examples/index.html>
=end para
=head2 file:
=begin para
Either L<file:/usr/local/lib/.configrc> or L<file:~/.configrc>. Either 
L<file:.configrc> or L<file:CONFIG/.configrc>.
=end para
=head2 mailto:
=begin para
Please forward bug reports to L<mailto:devnull@rt.cpan.org>
=end para
=head2 man:
=begin para
Unix L<man:find(1)> facilities.
=end para
=head2 doc:
=begin para
You may wish to use L<doc:Data::Dumper> to view the results. See also: 
L<doc:perldata>.
=end para
=head2 defn:
=begin para
prone to lexiphania : an unfortunate proclivity
=end para
=begin para
To treat his chronic L<defn:lexiphania> the doctor prescribed
=end para
=head2 isbn: and issn:
=begin para
The Perl Journal ( L<issn:1087-903X>).
=end para
=end pod];
$output = $p6.parse( $pod5 ).join("\n");
eq_or_diff( $output, $pod6, 'p13-link.pod format L<link> 5->6' );

