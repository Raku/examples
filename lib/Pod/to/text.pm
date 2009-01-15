# Pod::to::text - convert Perl 6 documentation to plain text

use Pod::Parser;

class Pod::to::text is Pod::Parser
{
    has Bool $!newline_before_head;
    has Bool $!newline_before_para;

    method doc_beg( Str $name ) {
        $!margin_L     = 4;
        $!margin_R     = 79;
        $!needspace    = Bool::False;
        $!wrap_enable  = Bool::True;
        $!buf_out_enable = Bool::True;
        $!newline_before_head = Bool::False;
        $!newline_before_para = Bool::False;
    }

    method blk_beg( $refblock ) {
        my Str $typename = $refblock<typename>;
        given $typename {
            when 'pod'  { $!newline_before_para = Bool::False; }
            when 'head' { if $!newline_before_head { self.emit(''); }
                          my $level = int $refblock<config><level>;
                          $!margin_L = ($level - 1) * 2; }
            when 'para' { if $!newline_before_para { self.emit(''); }
                          $!newline_before_head = Bool::True;
                          $!margin_L = 4; }
            when 'code' { if $!newline_before_para { self.emit(''); }
                          $!newline_before_head = Bool::True;
                          $!wrap_enable = Bool::False;
                          $!margin_L = 4; }
        }
    }

    method fmt_beg( $refblock ) {
        my $typename = $refblock<typename>;
        given $typename {
            when 'B' { $!needspace = Bool::False; } # basis
            when 'D' { $!needspace = Bool::False; } # definition
            when 'L' {                              # link
                my Str $alt      = ~ $refblock<config><alternate>;
                my Str $scheme   = ~ $refblock<config><scheme>;
                my Str $external = ~ $refblock<config><external>;
                my Str $internal = ~ $refblock<config><internal>;
                $!needspace = Bool::False;
                my $link;
                if $external ne '' and $internal ne '' { $link = "$external#$internal" }
                else { $link = "$external$internal"; }
                my $visible = $external;
                given $scheme {
                    when 'http' | 'https' { $visible = "$scheme:$link";}
                    when 'doc'            { $visible = $link; }
                }
                if $alt ne '' { $visible = $alt; }
                self.buf_print( $visible );
                $!needspace = Bool::False;
                $!buf_out_enable = Bool::False;
            }
        }
    }

    method content( $reftopblock, Str $content ) {
        self.buf_print( $content );
        if $!codeblock { self.buf_flush; }
    }

    method fmt_end( $refblock ) {
        my $typename = $refblock<typename>;
        given $typename {
            when 'B' { $!needspace = Bool::False; } # basis
            when 'D' { $!needspace = Bool::False; } # definition
            when 'L' { $!needspace = Bool::False;   # link
                       $!buf_out_enable = Bool::True; }
        }
    }

    method blk_end( $refblock ) {
        my Str $typename = $refblock<typename>;
        self.buf_flush;
        given $typename {
            when 'head' {
                $!newline_before_head = Bool::False;
                $!newline_before_para = Bool::False;
            }
            when 'para' {
                $!newline_before_head = Bool::True;
                $!newline_before_para = Bool::True;
            }
            when 'code' {
                $!newline_before_head = Bool::True;
                $!newline_before_para = Bool::True;
            }
        }
    }

    method doc_end { }              # suppress Pod::Parser output
    method ambient( Str $line ) { } # suppress Pod::Parser output
}

=begin pod

=head1 NAME
Pod::to::text - translate Plain Old Documentation (POD) to text

=head1 SYNOPSIS
=begin code
# in Perl 6 (Rakudo)
#!/usr/local/bin/perl6
use v6;
use Pod::to::text;
my Pod::to::text $translator .= new;
my Str $podfilename = @*ARGS[0];
$translator.parse_file( $podfilename );
# or in shell
perl6 -e 'use Pod::to::text; Pod::to::text.new.parse_file(@*ARGS[0])' lib/Pod/to/text.pm
=end code

=head1 DESCRIPTION
L<doc:Pod::to::text> is the plain text emitter used by the pod2text
utility.

=head1 BUGS
L<RT#62030|http://rt.perl.org/rt3/Public/Bug/Display.html?id=62030> after
r34090 Rakudo -e ignores command line arguments for @*ARGS,
so the L<#SYNOPSIS> shell example above does not get the file name.
r35568: .pm -> .pir Lexical 'self' not found

=head1 SEE ALSO
L<doc:Pod::Parser>

=end pod

