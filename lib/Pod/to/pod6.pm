# Pod::to::pod6 - convert any POD (Perl 5 or 6) to Perl 6 POD format

use Pod::Parser;

class Pod::to::pod6 is Pod::Parser
{
    has Str  $!pod6context;

    method doc_beg( Str $name ) {
        $!pod6context = 'AMBIENT';
        $!margin_R = 72;
    }

    method blk_beg( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        given $typename {
            when 'pod' {
                $!needspace = Bool::False;
                self.buf_print( "=begin pod" );
                self.buf_flush;
            }
            when 'head' {
                $!pod6context = 'HEAD';
                my $level = $podblock.config<level>;
                $!wrap_enable = Bool::False;
                self.buf_print( "=head$level " );
                $!needspace = Bool::False;
            }
            when 'para' {
                $!pod6context = 'PARA';
                $!wrap_enable = Bool::True;
                $!needspace = Bool::False;
                self.buf_print( '=begin para' );
                self.buf_flush;
                $!needspace = Bool::False;
            }
            when 'code' {
                $!pod6context = 'CODE';
                $!wrap_enable = Bool::False;
                self.buf_print( '=begin code' );
                self.buf_flush;
            }
        }
    }

    method fmt_beg( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        given $typename {
            when 'B' { self.buf_print( 'B<' ); } # basis
            when 'C' { self.buf_print( 'C<' ); } # code
            when 'D' { self.buf_print( 'D<' );
                                               } 
#                      $!needspace = Bool::False; } # definition
            when 'L' { self.buf_print( 'L<' ); } # link
            default { }
        }
        $!needspace = Bool::False;
    }

    method content( PodBlock $podblock, Str $content ) {
        given $!pod6context {
            when 'HEAD' { self.buf_print( $content ); }
            when 'PARA' {
                $!needspace &&= substr($content,0,1) ne " ";
                self.buf_print( $content );
                $!needspace = (substr($content,$content.chars-1,1) ne " ");
            }
            when 'CODE' { self.emit( $content ); }
                # always prepending a space to lines in a code block is
                # simple but crude. It might hinder POD6<->POD5 round
                # trip testing.
        }
    }

    method fmt_end( PodBlock $podblock ) {
        my Str $typename = $podblock.typename;
        $!needspace = Bool::False;
        given $typename {
            when 'B' { self.buf_print( '>' ); } # basis
            when 'C' { self.buf_print( '>' ); } # code
            when 'D' { self.buf_print( '>' ); } # definition
            when 'L' { self.buf_print( '>' ); } # definition
            default { }
        }
        $!needspace = Bool::False;
    }

    method blk_end( PodBlock $podblock ) {
        self.buf_flush;
        my Str $typename = $podblock.typename;
        given $typename {
            when 'code' { self.emit( '=end code' ); }
            when 'para' { self.emit( '=end para' ); }
            when 'pod'  { self.emit( "=end pod" ); }
        }
        $!pod6context = 'AMBIENT';
    }

    method doc_end {
        if $!pod6context ne 'AMBIENT' {
            self.buf_flush;
            self.emit( "=end pod" );
        }
    }

    method ambient( Str $line ) {
        if $line eq '' {
            self.emit( '' );
        }
        else {
            $!wrap_enable = Bool::False;
            self.buf_print( $line );
            self.buf_flush;
        }
    }
}

=begin pod
=head1 NAME
Pod::to::pod6 - translate any pod to Perl 6 pod
=head1 SYNOPSIS

    # in Perl 6 (Rakudo)
    use v6;
    use Pod6::to::pod6;
    my Pod::to::pod6 $to_pod6 .= new;
    my $podfilename = 'Pod_to_pod6.pm';
    $to_pod6.translate( $podfilename );

    # in bash
    SCRIPT='use Pod::to::pod6;my $p=Pod::to::pod6.new;'
    SCRIPT=$SCRIPT'$p.parse_file(@*ARGS[0]);' # or both on one line
    perl6 -e $SCRIPT podfile

=head1 DESCRIPTION
=head1 BUGS
Incomplete.
=head1 SEE ALSO
L<doc:Pod::Parser>
=end pod
