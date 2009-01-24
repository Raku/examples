# Pod::to::pod5 - convert Perl 6 documentation to Perl 5

use Pod::Parser;

class Pod::to::pod5 is Pod::Parser
{
    has      $!pod5context; # AMBIENT POD5 HEAD PARA CODE
                            # TODO: rewrite as enum
    has Bool $!doneblankline;

    method doc_beg( Str $name ) {
        $!pod5context   = 'AMBIENT';
        $!doneblankline = Bool::True;
        $!needspace     = Bool::False;
        $!wrap_enable   = Bool::True;
        $!margin_R      = 72;
    }

    method blk_beg( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        given $typename {
            when 'pod' {
                $!pod5context = 'POD5';
                self.ensureblankline;
                self.buf_print( "=pod" );
                self.buf_flush;
                $!doneblankline = Bool::False;
                self.ensureblankline;
            }
            when 'head' {
                $!pod5context = 'HEAD';
                self.ensureblankline;
                my $level = $podblock.config<level>;
                $!wrap_enable = Bool::False;
                self.buf_print( "=head$level " );
                $!needspace = Bool::False;
            }
            when 'para' {
                $!pod5context = 'PARA';
                $!needspace = Bool::False;
                $!wrap_enable = Bool::True;
            }
            when 'code' {
                $!pod5context = 'CODE';
                $!wrap_enable = Bool::False;
            }
        }
    }

    method fmt_beg( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        given $typename {
            when 'B' { self.buf_print( 'B<' ); } # basis
            when 'C' { self.buf_print( 'C<' ); } # code
            when 'L' { self.buf_print( 'L<' ); } # link
            default { }
        }
        $!needspace = Bool::False;
    }

    method content( PodBlock $podblock, Str $content ) {
        given $!pod5context {
            when 'HEAD' {
                self.buf_print( $content );
            }
            when 'PARA' {
                $!needspace = $!needspace and (substr($content,0,1) ne " ");
                self.buf_print( $content );
                $!needspace = (substr($content,$content.chars-1,1) ne " ");
            }
            when 'CODE' {
                self.buf_print( " $content" );
                self.buf_flush;
                $!doneblankline = Bool::False;
                # always prepending a space to lines in a code block is
                # simple but crude.
                # It will make POD6<->POD5 round trip testing harder.
            }
        }
        $!doneblankline = ($content eq '');
    }

    method fmt_end( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        given $typename {
            when 'B' { $!needspace = Bool::False;
                       self.buf_print( '>' );
                       $!needspace = Bool::False; } # basis
            when 'C' { $!needspace = Bool::False;
                       self.buf_print( '>' );
                       $!needspace = Bool::False; } # basis
            when 'L' { $!needspace = Bool::False;
                       self.buf_print( '>' );
                       $!needspace = Bool::False; } # basis
            default { }
        }
    }

    method blk_end( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        given $typename {
            when 'code' {
                self.ensureblankline;
            }
            when 'para' {
                self.buf_flush;
                $!doneblankline = Bool::False;
                self.ensureblankline;
            }
            when 'head' {
                self.buf_flush;
                $!doneblankline = Bool::False;
                self.ensureblankline;
            }
            when 'pod' {
                self.ensureblankline;
                $!needspace = Bool::False;
                self.buf_print( "=cut" );
                self.buf_flush;
                $!doneblankline = Bool::False;
                $!pod5context = 'AMBIENT';
            }
        }
    }

    method doc_end {
        if $!pod5context ne 'AMBIENT' {
            # should maybe output a warning about badly formed document.
            self.ensureblankline;
            self.buf_print( "=cut" );
            self.buf_flush;
            $!doneblankline = Bool::False;
        }
    }

    method ambient( Str $line ) {
        if $line eq '' {
            $!doneblankline = Bool::False;
            self.ensureblankline;
        }
        else {
            $!wrap_enable   = Bool::False;
            self.buf_print( $line );
            self.buf_flush;
            $!doneblankline = Bool::False;
        }
    }
    
    method ensureblankline {
        unless $!doneblankline {
            self.emit( "" );
            $!doneblankline = Bool::True;
        }
    }
}

=begin pod
=head1 NAME
Pod6_to_pod5 - translate Perl 6 Documentation to Perl 5 format
=head1 SYNOPSIS

    # in Perl 6 (Rakudo)
    use v6;
    use Pod::to::pod5;
    my Pod::to::pod5 $to_pod5 .= new;
    my $podfilename = 'to/pod5.pm';
    $to_pod5.parse_file( $podfilename );

    # from shell
    perl6 -e'use Pod::to::pod5;Pod::to::pod5.new.parse_file(@*ARGS[0]);' to/pod5.pm

=head1 DESCRIPTION
Translates Perl 6 Documentation (POD6) to Perl 5 format (POD5).
Ambient content (the remaining, non POD text) is preserved.
Eventually an option to drop the ambient content might be added.

If the file being translated contains Perl 6 source code, the output
will probably contain Perl 5 POD that is incompatible with Perl 6,
for example =cut.
This kind of file would fail a picky Perl 6 processor, although Rakudo
does not mind.
Still, this module picks the POD5 and keeps the problem to a minimum.
=head1 BUGS
Incomplete.

The POD5 output generated by the test suite is not (yet) automatically
checked by the Perl 5 podchecker.
The test cases in t/05-Pod_to_pod5.t are being checked manually.
=head1 SEE ALSO
L<doc:Pod::Parser>.
From Perl 5: perlpod perlpodspec perldoc podchecker
=end pod

