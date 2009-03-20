# Pod::to::xhtml - convert Perl 6 documentation to XHTML

use Pod::Parser;

$*stylesheet = q[code { font-size:large; font-weight:bold; }
h1 { font-family:helvetica,sans-serif; font-weight:bold; }
h2 { font-family:helvetica,sans-serif; font-weight:bold; }
pre { font-size: 10pt; background-color: lightgray; border-style: solid;
 border-width: 1px; padding-left: 1em; }];  # TODO: use heredoc

class Pod::to::xhtml is Pod::Parser
{
    has Int  $!indentlevel;
    has Str  $!name;
    has Str  $!prefix;
    has Str  $!buffer;
    has Bool $!do_emit;
    has Bool $!do_definition;
    has Str  $!definition;
    has Str  @!warnings;

    method doc_beg( $name ) {
        $!margin_R      = 79;
        $!indentlevel   = 0;
        $!name          = $name;
        $!prefix        = '';
        $!buffer        = '';
        $!do_emit       = Bool::True;
        $!buf_out_enable = Bool::True;
        $!needspace     = Bool::False;
        $!codeblock     = Bool::False;
        $!do_definition = Bool::False;
        $!definition    = '';
        self.buf_print( '<?xml version="1.0" ?>' );
        self.buf_flush;
        self.buf_print( '<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">' );
        self.buf_flush;
        self.buf_print( '<html xmlns="http://www.w3.org/1999/xhtml">' );
        self.buf_flush;
        self.emit( "<head><title>$!name</title>" );
        self.emit( '<style type="text/css">' );
        for $*stylesheet.split("\n") -> $s { self.emit( $s ); }
        self.emit( "</style>" );
        self.emit( "</head>" );
        self.emit( '<body>' );
    }

    method blk_beg( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        $!prefix = ' ' x ($!indentlevel * 4);
        $!margin_L = $!indentlevel * 4;
        if $typename ne 'head' {
            $!indentlevel++;
        }
        given $typename {
            when 'pod' { }
            when 'head' {
                my $level = $podblock.config<level>;
                my $hlevel = ( $level > 4 ) ?? 4 !! $level;
                self.emit("");
                self.buf_print( "<h$level>" );
                $!needspace = Bool::False;
            }
            when 'para' {
                self.emit("");
                self.buf_print( "<p>" );
                $!needspace = Bool::False;
            }
            when 'code' { 
                self.buf_print( "<pre>" );
                self.buf_flush;
                self.emit( "" );
                $!codeblock = Bool::True;
            }
            when 'comment' { }
            default {
                self.emit( '<block typename="' ~ $typename ~ '">' );
            }
        }
    }

    method fmt_beg( PodBlock $podblock ) {
        my $typename = $podblock.typename;
        given $typename {
            when 'B' { self.buf_print( '<strong>' );
                       $!needspace = Bool::False; }
            when 'C' { self.buf_print( '<code>' );
                       $!needspace = Bool::False;}
            when 'D' { $!do_definition = Bool::True;
                       $!do_emit = Bool::False;
                       $!buf_out_enable = Bool::False;
                     }
#           when 'I' { self.buf_print( '<em>'     ); $!needspace = Bool::False; }
            when 'L' { self.format_link( $podblock ); }
#           when 'Z' { self.buf_print( '<!--Z'    ); }
            default {
                self.buf_print( "<$typename>" );
            }
        }
    }

    method format_link( PodBlock $podblock ) {
        my Str $alt      = ~ $podblock.config<alternate>;
        my Str $scheme   = ~ $podblock.config<scheme>;
        my Str $external = ~ $podblock.config<external>;
        my Str $internal = ~ $podblock.config<internal>;
        my $link = $external
                ~ ( ($external ne '' and $internal ne '')
                        ?? '#' !! '' )
                ~ $internal;
        given $scheme {
            when 'http' | 'https' {
                if $link.substr(0,1) eq '/' { $link = "$scheme:$link"; }
                my $visible = ($alt eq '') ?? $link !! $alt;
                $link = "<a href=\"$link\">$visible</a>";
            }
            when 'mailto' {
                $link = "<a href=\"mailto:$external\">$external</a>";
            }
            when 'file' {
                $link = "<a href=\"file://$external\">$external</a>";
            }
            when 'doc' {
                $link = ($alt eq '') ?? $link !! $alt;
                my $path = $external.split('::').join('/');
                if $internal eq '' {
                    $link = "<a href=\"http://perldoc.perl.org/$path.html\">$link</a>";
                }
            }
            when 'defn' {
                $link = "<a href=\"#$external\">$external</a>";
            }
        }
        self.buf_print( $link );
        $!do_emit = Bool::False;
        $!buf_out_enable = Bool::False;
    }

    method content( PodBlock $podblock, Str $content is copy ) {
        my Str $text = $content;
        $text .= subst( /\&/,   { '&amp;' },:global );
        $text .= subst( /<lt>/, { '&lt;' }, :global );
        $text .= subst( /<gt>/, { '&gt;' }, :global );
        $!needspace = $!needspace and (substr($content,0,1) ne " ");
        if $!do_definition {
            $!definition ~= $text;
        }
        if $!codeblock { self.emit( $text ); }
        else           { self.buf_print( $text ); }
        $!needspace = (substr($content,$content.chars-1,1) ne " ");
    }

    method fmt_end( PodBlock $podblock ) {
        my $typename = $podblock.typename;
        $!do_emit = Bool::True;
        $!buf_out_enable = Bool::True;
        $!needspace = Bool::False;
        given $typename {
            when 'B' { self.buf_print( '</strong>' );
                       $!needspace = Bool::False; }
            when 'C' { self.buf_print( '</code>'   );
                       $!needspace = Bool::False; }
            when 'D' { $!do_emit = Bool::True;
                       $!buf_out_enable = Bool::True;
                       $!needspace = Bool::False;
                       self.buf_print( "<a name=\"" ~ $!definition ~ "\">" );
                       self.buf_print( $!definition );
                       $!definition = ''; $!do_definition = Bool::False;
                       self.buf_print( '</a>'      );
                     }
#           when 'I' { self.buf_print( '</em>'     ); $!needspace = Bool::False; }
            when 'L' { }
#           when 'Z' { self.buf_buf( 'Z-->'      ); }
            default {
                self.buf_print( "</$typename>" );
            }
        }
    }

    method blk_end( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        if $typename ne 'head' and $typename ne 'para' {
            self.buf_flush;
            $!prefix = ' ' x (--$!indentlevel * 4);
            $!margin_L = $!indentlevel * 4;
        }
        given $typename {
            when 'head' {
                my $level = $podblock.config<level>;
                my $hlevel = ( $level > 4 ) ?? 4 !! $level;
                $!needspace = Bool::False;
                self.buf_print( "</h$hlevel>" );
                self.buf_flush;
            }
            when 'para' {
                $!needspace = Bool::False;
                self.buf_print( "</p>" );
                self.buf_flush;
                --$!indentlevel;
                $!margin_L = $!indentlevel * 4;
            }
            when 'code' { 
                self.buf_print( "</pre>" );
                self.buf_flush;
                $!codeblock = Bool::False;
            }
            when 'pod' { }
            when 'comment' { }
            default {
                self.buf_print( '</block typename="' ~ $typename ~ '">' );
                self.buf_flush;
            }
        }
    }

    # override the Pod::Parser base class emitters that output messages
    method doc_end {
        self.buf_print( '</body>' );
        self.buf_flush;
        self.buf_print( '</html>' );
        self.buf_flush;
    }
    method ambient( $line ) { }
}

=begin pod

=head1 NAME
Pod::to::xhtml - convert Perl 6 documentation to xhtml

=head1 SYNOPSIS
=begin code
#!/usr/local/bin/perl6
# pod2xhtml script in Perl 6 (Rakudo)
use Pod::to::xhtml;
my Pod::to::xhtml $translator .= new;
my $podfilename = @*ARGS[0] // 'to/xhtml.pm';
$translator.parse_file( $podfilename );
=end code
or in shell (all on one line):
=begin code
perl6 -e'use Pod::to::xhtml;Pod::to::xhtml.new.parse_file(@*ARGS[0])' to/xhtml.pm
=end code

=head1 DESCRIPTION
The Pod6_to_xhtml module does B<xhtml> output formatting
for L<doc:Pod::Parser>.

=head2 Style Sheet
Currently CSS is hard coded into a C< <style> > element in the
C< <head> > block. Other CSS ideas to be implemented are 1) refer to an
external CSS file and insert its content into the XHTML, and 2) specify
the URI to point an external stylesheet file.

=head1 BUGS
1) Rendering an L < link > does not set the C<href> attribute properly.

2) Extra horizontal and vertical space sneaks into the rendering of C < >
text and indented (verbatim) text.

3) extra space at end of para.

=head1 TODO
Refactor to use buf_print() and buf_flush.

Unimplemented formatting codes. Table of Contents. CSS refer or embed.

=head1 SEE ALSO
L<doc:Pod::Parser> L<S26|http://perlcabal.org/syn/S26.html>

=head1 AUTHOR
Martin Berends (mberends on CPAN, #perl6, #parrot and @flashmail.com).

=end pod
