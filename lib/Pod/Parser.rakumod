# lib/Pod/Parser.pm - Perl 6 Plain Old Documentation parser

# Names, meanings and sequence according to Synopsis 26 - Documentation

grammar Pod6 {
    regex directive { <begin> | <end> | <for> | <extra> |
                      <head>  | <para> | <code> | <input> | <output> |
                      <item>  | <nested> | <table> | <comment> |
                      <END> | <DATA> | <semantic> |
                      <encoding> | <config> | <use> |
                      <p5pod> | <p5over> | <p5back> | <p5cut> };
    # fundamental directives 
    regex begin    { ^ '=begin' <.ws> <typename> [ <.ws> <option> ]* };
    regex end      { ^ '=end'   <.ws> <typename> };
    regex for      { ^ '=for'   <.ws> <typename> [ <.ws> <option> ]* };
    regex extra    { ^ '='                       [ <.ws> <option> ]+ };
    regex typename { code | comment | head\d+ | input | output | para | pod | table };
    # standard block types (section Blocks in order of appearance in S26)
    regex head     { ^ '=head'<level> <.ws> <heading> };
    regex para     { ^ '=para'    <.ws> <txt> };
    regex code     { ^ '=code'                   [ <.ws> <option> ]* };
    regex input    { ^ '=input'   <.ws> <txt> };
    regex output   { ^ '=output'  <.ws> <txt> };
    regex item     { ^ '=item'    <.ws> <txt> };
    regex nested   { ^ '=nested'  <.ws> <txt> };
    regex table    { ^ '=table'   <.ws> <txt> };
    regex comment  { ^ '=comment' <.ws> <txt> };
    regex END      { ^ '=END'     <.ws> <txt> };
    regex DATA     { ^ '=DATA'    <.ws> <txt> }; 
    regex semantic { ^ '='<[ A..Z ]>+ };
    # other directives (pre-configuration, modules)
    regex encoding { ^ '=encoding' <.ws> <txt> };
    regex config   { ^ '=config' <.ws> <typename> [ <.ws> <option> ]* };
    regex use      { ^ '=use'      <.ws> <txt> };
    # optional backward compatibility with Perl 5 POD
    regex p5pod    { ^ '=pod'                }; # begin Perl 5 POD 
    regex p5over   { ^ '=over' <.ws> <level> }; # begin Perl 5 indent
    regex p5back   { ^ '=back'               }; # end Perl 5 indent
    regex p5cut    { ^ '=cut'                }; # end Perl 5 POD
    # building blocks
    regex txt      { .* };
    regex heading  { .+ };
    regex blank    { ^ <.ws>? $ };
    regex level    { <.digit>+ };
    regex option   { <option_false> | <option_true> | <option_string> };
    regex option_false  { ':!' <option_key> |
                          ':'  <option_key> '(' <.ws>? '0'  <.ws>? ')' |
                          ':'  <option_key> <.ws>? '=' <.gt> <.ws>? '0'
                        };
    regex option_true   {
    # problem: the next line masks option_string?
    #                     ':' <option_key> | # TODO: reinstate
                          ':' <option_key> '(' <.ws>? '1'  <.ws>? ')' |
                          ':' <option_key>     <.ws>? '=>' <.ws>?    '1'
                        };
    # would token or rule be better than regex above?
    regex option_string { ':' <option_key> <.lt> <option_value> <.gt> };
    regex option_key    { <.ident> };
    regex option_value  { .* };
}

grammar Pod6_link {
    regex TOP { <alternate> [ <ws> '|' <ws> ] ? <scheme> <external> <internal> }
    regex alternate { [ .* <?before [ <ws> '|' <ws> ] > ] ?  }
    regex scheme { [ [ http | https | file | mailto | man | doc | defn
        | isbn | issn ] ? ':' ] ? } # TODO: non standard schemes
    regex external { [ <-[#]> + ] ? }
    regex internal { [ '#' .+ ] ? }
}

# RAKUDO: add 'is rw' on the class instead [perl #60636]
class PodBlock {
    has Str $.typename is rw;
    has Str $.style    is rw;
    has %.config   is rw;
    method perl {
        my Str $typename = $.typename // 'undef';
        my Str $style    = $.style    // 'undef';
        return "( 'typename'=>'$typename', 'style'=>'$style' )";
    }
};

enum Context <AMBIENT BLOCK_DECLARATION POD_CONTENT>;

class Pod::Parser {
    # attributes, alphabetically
    has Bool     $!buf_out_enable = Bool::True; # for Z<> to suppress output
    has Str      $!buf_out_line;                # where buf_print puts text
    has Bool     $!codeblock;                   # True within =begin code / =end code
    # has        %!config;                      # for =config definitions
    has Context  $!context;                     # which state is the parser in?
    has Str      $!line;                        # current line being processed
    has Int      $!margin_L;                    # first output column - default 0
    has Int      $!margin_R;                    # last output column - default 79
    has Match    $!match;                       # result of $!line matching a regex
    has Bool     $!needspace;                   # would require ' ' if more text follows

    # $*OUT broke in r35311, reported in RT#62540
    has IO       $!outfile;                     # could be replaced by select()

    has PodBlock @!podblocks;                   # stack of nested Pod blocks
    has Bool     $!wrap_enable;                 # do word wrap between margins

    method parse_file( Str $filename )
    {
        $!context        = Context::AMBIENT;
#       $!outfile        = $*OUT;     # for possible redirection to other files
        $!buf_out_line   = '';
        $!wrap_enable    = Bool::True;
        $!codeblock      = Bool::False;
        $!needspace      = Bool::True;
        $!margin_L       = 0;
        $!margin_R       = 79;
        # @!podblocks is wrongly vivified with a single element (RT#62838)
        if @!podblocks { @!podblocks.pop; }
        # say "STACK: {@!podblocks.perl}";

        # the main stream based parser begins here
        self.doc_beg( $filename );
        for lines($filename) -> Str $line  { $!line = $line; self.parse_line; }
#       for lines($filename) -> Str $!line {                 self.parse_line; }
        self.doc_end;
    }

    # TODO: change most following methods to submethods ASAP
    method parse_line { # from parse_file
        given $!line {
            when /<Pod6::directive>/ { self.parse_directive; } # '=xx :cc'  /
            when /<Pod6::extra>/     { self.parse_extra; }     # '=    :cc' /
            when /<Pod6::blank>/     { self.parse_blank; }     # '' or ' '  /
            default { if @!podblocks { self.parse_content; }   # 'xx' or ' xx'
                      else           { self.ambient($!line); } # outside pod
            }
        }
    }

    method parse_directive { # from parse_line
        given $!line {
            # Keywords from Synopsis 26 section "markers"
            when / <Pod6::begin>    / { self.parse_begin(    $/ ); }
            when / <Pod6::end>      / { self.parse_end(      $/ ); }
            when / <Pod6::for>      / { self.parse_for(      $/ ); }
            # Keywords from Synopsis 26 section "Blocks"
            when / <Pod6::code>     / { self.parse_code(     $/ ); }
            when / <Pod6::comment>  / { self.parse_comment(  $/ ); }
            when / <Pod6::head>     / { self.parse_head(     $/ ); }
            when / <Pod6::input>    / { } # /
            when / <Pod6::item>     / { } # /
            when / <Pod6::nested>   / { } # /
            when / <Pod6::output>   / { } # /
            when / <Pod6::table>    / { } # /
            when / <Pod6::DATA>     / { } # /
            when / <Pod6::END>      / { } # /
            # Keywords from Synopsis 26 section "Block pre-configuration"
            when / <Pod6::encoding> / { } # /
            when / <Pod6::config>   / { self.parse_config(   $/ ); }
            when / <Pod6::use>      / { } # /
            # Keywords from Perl 5 POD
            when / <Pod6::p5pod>    / { self.parse_p5pod; } # /
            when / <Pod6::p5over>   / { } # /
            when / <Pod6::p5back>   / { } # /
            when / <Pod6::p5cut>    / { self.parse_p5cut;} # /
            default                   {
                                        # self.parse_user_defined;
                                      } # /
        }
    }

    method parse_extra { # from parse_line
        if $!context != Context::BLOCK_DECLARATION {
            warning "extended configuration without marker";
        };
        # TODO: parse various pair notations
    }

    method parse_blank { # from parse_line
        if @!podblocks { # in some POD block
            my Str $style = @!podblocks[*-1].style;
            if $style eq ( 'PARAGRAPH' | 'ABBREVIATED' | 'FORMATTING_CODE' ) {
                # TODO: consider loop for possible nested formatting codes still open
                self.set_context( Context::AMBIENT ); # close paragraph block
            }
            elsif @!podblocks[*-1].typename eq 'code' {
                self.content( @!podblocks[*-1], '' ); # blank line is part of code
            }
        }
        else { self.ambient( '' ); } # a non POD part of the file
    }

    method parse_content { # from parse_line
        self.set_context( Context::POD_CONTENT );
        # (hopefully not premature) optimization: format only if contains < or > chars.
        if $!line ~~ / <lt> | <gt> | '«' | '»' / {
            self.parse_formatting;
        }
        else {
            self.content( @!podblocks[*-1], $!line );
        }
    }

    method parse_formatting { # from parse_content and parse_head
        # It is valid to call parse_formatting with lines that do not
        # contain formatting, it just wastes a bit of time.
        my Str $content = $!line;
        while $content.chars > 0 {
            my Str $format_begin;
            my Str $angle_L; #  « | < | << | <<< etc char(s) found
            my Str $angle_R; #  >>> | >> | > | »     char(s) to find
            # For the "no formatting codes found" (most common) case, set
            # these character pointers to beyond the end of the content.
            my Int $format_begin_pos = $content.chars;
            my Int $angle_L_pos      = $content.chars;
            my Int $angle_R_pos      = $content.chars;
            my Int $chars_to_delete  = $content.chars;
            my Str $output_buffer    = $content; # assuming all formatting done
            # Check for possible formatting codes opened in previous content
            if @!podblocks[*-1].style eq 'FORMATTING_CODE' {
                # Found an open formatting code. Get its delimiters.
                # TODO: check that it is enough to look only at the
                # innermost block (last pushed). For example, what if
                # '=begin comment' is nested inside a format block (S26)?
                $angle_L = @!podblocks[*-1].config<angle_L>;
                $angle_R = @!podblocks[*-1].config<angle_R>;
                # Search for possible nested delimiters.
                # eg this 'C< if $a < $b or $a > $b >' is all code.
                #      $angle_L_pos ^          ^ $angle_R_pos
                if $content.index( $angle_L ) {
                    $angle_L_pos = $content.index( $angle_L );
                }
                if $content.index( $angle_R ) {
                    $angle_R_pos = $content.index( $angle_R );
                }
            }
            # Search for a formatting code opening sequence eg 'C<'
            # TODO: rewrite pattern with variable list of allowed codes
            # TODO: also allow French quotes on formatting codes
            #if$content ~~ / (.*?)(<[BCDEIKLMNPRSTUVXZ]>)(\<+|'«')(.*) / {
            if $content ~~ / (.*?)(<[BCDEIKLMNPRSTUVXZ]>)(\<+)(.*) / {
                # captures    $0   $1                     $2   $3
                # Found a formatting code opening sequence
                my Str $before          = ~ $0;
                $format_begin           = ~ $1;
                my Str $new_angle_L     = ~ $2;
                my Str $after           = ~ $3;
                $format_begin_pos       = $1.from;
                my Int $format_end_pos  = $2.to;
                if $format_begin_pos < $angle_L_pos and
                   $format_begin_pos < $angle_R_pos {
                    # This formatting code is leftmost in the content
                    if $format_begin_pos > 0 {
                        # There is text before the new formatting code
                        my Str $before = $content.substr( 0, $format_begin_pos );
                        self.content( @!podblocks[*-1], $before );
                    }
                    my Str $new_angle_R = $new_angle_L eq '«' ?? '»' !!
                        '>' x $new_angle_L.chars;
                    my PodBlock $formatcodeblock .= new(
                        typename => $format_begin,
                        style    => 'FORMATTING_CODE',
                        config   => { 'angle_L' => $new_angle_L,
                                      'angle_R' => $new_angle_R }
                    );
                    if $format_begin eq 'L' {
                        parse_link( $/, $formatcodeblock );
                    }
                    @!podblocks.push( $formatcodeblock );
                    self.fmt_beg( $formatcodeblock );
                    $chars_to_delete = $format_end_pos;
                    $output_buffer = "";
                }
            }
            # Look for the same delimiter as the innermost format uses,
            # such as C<< some time earlier,
            # and then $a<<=1; $b>>=1; >>
            if $angle_L_pos < $format_begin_pos and
               $angle_L_pos < $angle_R_pos {
                # the opening delimiter was first, so remember it on the
                # stack. That way the first closing delimiter will
                # balance this one, and the second closing delimiter
                # will end the formatting code.
                my PodBlock $formatcodeblock .= new(
                    typename => "NESTED_ANGLE_BRACKET",
                    style    => 'FORMATTING_CODE',
                    config   => { 'angle_L' => $angle_L,
                                  'angle_R' => $angle_R }
                );
                @!podblocks.push( $formatcodeblock );
                $output_buffer = $content.substr( 0, $angle_L_pos + $angle_L.chars );
                $chars_to_delete = $angle_L_pos + $angle_L.chars;
            }
            elsif $angle_R_pos < $format_begin_pos and
                  $angle_R_pos < $angle_L_pos {
                # First in content is the current closing delimiter.
                # It will either balance an opening delimiter inside the
                # formatting code, or mark the end of the formatting code.
                my PodBlock $topblock = pop @!podblocks;
                my Str $typename = $topblock.typename;
                if $typename eq "NESTED_ANGLE_BRACKET" {
                    # The closing delimiter balances a nested opening delimiter
                    $output_buffer = $content.substr( 0, $angle_R_pos + $angle_R.chars );
                }
                else {
                    # The closing delimiter ends the formatting code
                    $output_buffer = $content.substr( 0, $angle_R_pos );
                    self.content( @!podblocks[*-1], $output_buffer );
                    $output_buffer = "";
                    self.fmt_end( $topblock );
                }        
                $chars_to_delete = $angle_R_pos + $angle_R.chars;
            }
            if $output_buffer.chars > 0 {
                self.content( @!podblocks[*-1], $output_buffer );
            }
            $content = $content.substr( $chars_to_delete );
        }
    }

    sub parse_link( Match $match, PodBlock $podblock ) { # from parse_formatting
        # matched / (.*?)(<[BCDEIKLMNPRSTUVXZ]>)(\<+)(.*) /
        my Str $angle_R = $podblock.config<angle_R>;
        my Str $s = ~ $match[3];
        my Int $index = $s.index( $angle_R );
        my Str $link = $s.substr( 0, $index );
        if $link ~~ / <Pod6_link::TOP> / {
            $podblock.config<alternate> = ~ $/<Pod6_link::TOP><alternate>;
            $podblock.config<scheme>    = ~ $/<Pod6_link::TOP><scheme>;
            $podblock.config<external>  = ~ $/<Pod6_link::TOP><external>;
            $podblock.config<internal>  = ~ $/<Pod6_link::TOP><internal>;
            # tweak some of the link fields
            $podblock.config<scheme>   .= subst( / ^ $ /, {'doc'} ); # no scheme becomes doc
            $podblock.config<scheme>   .= subst( / \: $ /, { '' } ); # remove : from scheme:
            $podblock.config<internal> .= subst( / ^ \# /, { '' } ); # remove # from #internal
        }
    }

    method parse_begin( Match $match ) { # from parse_directive
        my Str $typename = ~ $match<Pod6::begin><typename>;
        self.set_context( Context::AMBIENT ); # finish any previous block
        self.set_context( Context::BLOCK_DECLARATION ); # push a protoblock
        @!podblocks[*-1].typename = $typename;  
        @!podblocks[*-1].style    = 'DELIMITED';
        given $typename {
            when 'pod'  { @!podblocks[*-1].config<version> = 6; }
            when 'code' { $!codeblock   = Bool::True;
                          $!wrap_enable = Bool::False; }
        }
    }

    method parse_end( Match $match ) { # from parse_directive
        self.set_context( Context::AMBIENT ); # pops PARAGRAPH style block
        my Str $endtypename = ~ $match<Pod6::end><typename>;
        if $endtypename ne @!podblocks[*-1].typename { # simple nesting error?
            # oops! either badly nested Pod or a bug in Parser.pm.
            # Does the Pod merely lack the innermost =end?
            if @!podblocks.elems >= 2 and @!podblocks[*-2].typename eq $endtypename {
                # assume a forgotten =end and forgive the error
                my $forgotten = pop @!podblocks;
                self.warning( "you probably forgot '=end " ~
                  "{$forgotten.typename}' before '=end $endtypename'" );
            }
        }
        if $endtypename eq @!podblocks[*-1].typename { # correct nesting
            self.blk_end( pop @!podblocks );
        }
        else { # a worse nesting error, so leave the stack alone.
            self.warning(   "the '=end $endtypename' " ~
                "has no matching '=begin $endtypename'" );
        }
        if $endtypename eq 'code' {
            $!codeblock   = Bool::False;
            $!wrap_enable = Bool::True;
        }
    }

    method parse_for( Match $match ) { # from parse_directive
        self.set_context( Context::BLOCK_DECLARATION );
        @!podblocks[*-1].typename = ~ $match<Pod6::for><typename>;
        @!podblocks[*-1].style    = 'ABBREVIATED';
    }

    method parse_code( Match $match ) { # from parse_directive
        say "STUB CODE";
    }

    method parse_comment( Match $match ) { # from parse_directive
        say "STUB COMMENT";
    }

    method parse_head( Match $match ) { # from parse_directive
        # when not in pod, =head implies Perl 5 =pod
        if + @!podblocks == 0 { self.parse_p5pod; } # inserts =pod version=>5

        my Str $heading = ~ $match<Pod6::head><heading>;
        self.set_context( Context::AMBIENT );        
        self.set_context( Context::BLOCK_DECLARATION ); # pushes a new empty block onto the stack
#       my Int $topindex = @!podblocks.end;
        @!podblocks[*-1].typename = 'head';
        @!podblocks[*-1].style    = 'POD_BLOCK';
        @!podblocks[*-1].config<level> = ~ $match<Pod6::head><level>;
        self.set_context( Context::POD_CONTENT ); # this one won't add a PARAGRAPH block
        $!line = ~ $match<Pod6::head><heading>;
        self.parse_formatting;
        self.blk_end( pop @!podblocks ); # the 'head'
        self.set_context( Context::AMBIENT );
    }

    method parse_config( Match $match ) { # from parse_directive
        say "STUB CONFIG";
    }

    method parse_p5pod { # from parse_directive
        self.set_context( Context::AMBIENT ); # finish any previous block
        self.set_context( Context::BLOCK_DECLARATION ); # pushes protoblock
        @!podblocks[*-1].typename        = 'pod';
        @!podblocks[*-1].style           = 'DELIMITED';
        @!podblocks[*-1].config<version> = 5;
        self.set_context( Context::AMBIENT );           # issues blk_beg
    }

    method parse_p5cut { # from parse_directive
        self.set_context( Context::AMBIENT );
        my PodBlock $topblock = pop @!podblocks;
        if ( $topblock.typename ne 'pod' ) {
            # TODO: change to non fatal diagnostic
            die "=cut expected pod, got {$topblock.typename}";
        }
        self.blk_end( $topblock );
    }

    method set_context( Context $new_context ) {
        # manages the emission of context switch function calls
        # depending on the difference between old and new context types.

        # RAKUDO: Death when Str-comparing an uninitialized enum value.
        # [perl #63878] the following line works around the problem:
        $!context //= Context::AMBIENT; #/ (slash for p5 highlighters)

        if ( $new_context ne $!context ) {
            given $!context {
                when int Context::AMBIENT { } # RAKUDO: is int necessary? http://rt.perl.org/rt3/Public/Bug/Display.html?id=64046
                when int Context::BLOCK_DECLARATION {
                    self.blk_beg( @!podblocks[*-1] );
                }
                when int Context::POD_CONTENT {
                    my Str $style = @!podblocks[*-1].style;
                    if $style eq ( 'PARAGRAPH' | 'ABBREVIATED' ) {
                        self.blk_end( pop @!podblocks );
                    }
                }
                default {
                    # TODO: make better diagnostic and add unit test
#                   die "unknown old context: $sOld_context";
                }
            }
            given $new_context {
                when int Context::AMBIENT {
                    if @!podblocks {
                        if @!podblocks[*-1].style ne 'DELIMITED' {
                            # ABBREVIATED or POD_BLOCK
                            self.blk_end( @!podblocks[*-1] );
                        }
                    }
                }
                when int Context::BLOCK_DECLARATION {
                    @!podblocks.push( PodBlock.new );
                }
                when int Context::POD_CONTENT {
                    # if the only containing block is the outer 'pod',
                    # wrap this content in a PARAGRAPH style 'para' or 'code'
                    if @!podblocks == 1 {
                        $!codeblock = ? ( $!line ~~ / ^ <sp> / );
                        my PodBlock $newpodblock .= new(
                            typename => $!codeblock ?? 'code' !! 'para',
                            style    => 'PARAGRAPH',
                            config   => { }
                        );
                        self.blk_beg( $newpodblock );
                        @!podblocks.push( $newpodblock );
                    }
                }
                default {
                    # TODO: make better diagnostic and add unit test
#                   die "unknown new context: $sNew_context";
                }
            }
            $!context = $new_context;
        }
    }

    method buf_print( Str $text ) {
        if $!buf_out_enable {
            if $text eq "\n" {
                # "\n" is an out-of-band signal for a blank line
                self.buf_flush();      # this might never be necessary
                $!buf_out_line = "\n"; # bypass margins and word wrap
                self.buf_flush();      # the "\n" to becomes emit("")
            }
            else {
                my @words = $!wrap_enable ?? $text.split(' ') !! ( $text );
                for @words -> Str $word {
                    if $!buf_out_line.chars + ($!needspace ?? 1 !! 0)
                            + $word.chars > $!margin_R {
                        self.buf_flush();
                    }
                    if $!buf_out_line.chars < $!margin_L {
                        $!buf_out_line ~=
                            ' ' x ($!margin_L - $!buf_out_line.chars);
                        $!needspace = Bool::False;
                    }
                    $!buf_out_line ~= ($!needspace ?? ' ' !! '') ~ $word;
                    $!needspace = Bool::True;
                }
            }
        }
    }

    method buf_flush {
        if $!buf_out_line ne '' {
            self.emit( ~ ( $!buf_out_line eq "\n" ?? "" !! $!buf_out_line ) );
            # why is the ~ necessary?
            $!buf_out_line = '';
            $!needspace = Bool::False;
        }
    }

    # $*OUT broke in r35311, reported in RT#62540
    # method emit( Str $text ) { $!outfile.say: $text; }
    method emit( Str $text ) {
        if defined $!outfile { $!outfile.say: $text; } # workaround
        else                 {           say  $text; }
    }
    
    # override these in your subclass to make a custom translator
    method doc_beg(Str $name)   { self.emit("doc beg $name"); }
    method doc_end              { self.emit("doc end"); }
    method blk_beg(PodBlock $b) { self.emit("blk beg {$b.typename} {$b.style}"~config($b));}
    method blk_end(PodBlock $b) { self.emit("blk end {$b.typename} {$b.style}"); }
    method fmt_beg(PodBlock $f) { self.emit("fmt beg {$f.typename}<..."~config($f)); }
    method fmt_end(PodBlock $f) { self.emit("fmt end  {$f.typename}...>"); }
    method content(PodBlock $b,Str $t){ self.emit("content $t"); }
    method ambient(Str $t)      { self.emit("ambient $t"); }
    method warning(Str $t)      { self.emit("warning - $t"); }
    sub config( PodBlock $b ) {
        my @keys = $b.config.keys.sort; my Str $r = '';
        for @keys -> Str $key {
            $r ~= " $key=>{$b.config{$key}}";
        }
        return $r;
    }
}

=begin pod

=head1 NAME
Pod::Parser - stream based parser for Perl 6 Plain Old Documentation

=head1 SYNOPSIS
 # in Perl 6 (Rakudo) - see Makefile for install and test suggestions
 use v6;
 use Pod::Parser;
 my $p = Pod6Parser.new;
 $p.parse_file( "lib/Pod/Parser.pm" );

 # in shell (one line, for testing)
 perl6 -e 'use Pod::Parser; Pod::Parser.new.parse_file(@*ARGS[0]);' Parser.pm

=head1 DESCRIPTION
This module contains the base class for of a set of POD utilities such
as L<doc:perldoc>, L<doc:pod2text> and L<doc:pod2html>.

The default Pod::Parser output is a trace of parser events and document
content to the standard output. The default output is usually converted
by a translator module to produce plain text, a Unix man page, xhtml,
Perl 5 POD or any other format.

=head2 Emitters or POD Translators (Podlators)
These are in development:
text. man (groff). xhtml. wordcount. docbook. pod5 to and from.
More are very welcome. A podchecker would also be useful.

=head1 Writing your own translator
Copy the following template and replace xxx with your format name.
Avoid names that others have published, such as text, man or xhtml.
=begin code
# Pod/to/xxx.pm
use Pod::Parser;
class Pod::to::xxx is Pod::Parser {
    method doc_beg($name){ self.emit("doc beg $name"); }
    method doc_end       { self.emit("doc end"); }
    method blk_beg(PodBlock $b) { self.emit("blk beg {$b.typename} {$b.style}"~config($b));}
    method blk_end(PodBlock $b) { self.emit("blk end {$b.typename} {$b.style}"); }
    method fmt_beg(PodBlock $f) { self.emit("fmt beg {$f.typename}<..."~config($f)); }
    method fmt_end(PodBlock $f) { self.emit("fmt end  {$f.typename}...>"); }
    method content(PodBlock $b,Str $t){ self.emit("content $t"); }
    method ambient($t)   { self.emit("ambient $t"); }
    method warning($t)   { self.emit("warning $t"); }
}
=end code
Add your logic, replace the "emit()" arguments and try it. Write a test
script as described in L<#DIAGNOSTICS> and verify that it works.
The simplest example is the L<Pod::to::text> translator.

=head1 METHODS

=head2 parse_file

=head2 emit

=head2 buf_print

=head2 buf_flush

=config head1 :formatted<B U> :numbered

=head1 LIMITATIONS
Auto detect of Perl 5 POD only works with a subset of valid POD5
markers.

Formatting code L<doc:links> parse incorrectly when spanned over
multiple lines.

=head1 DIAGNOSTICS
Running parse_file without an overriding translator uses the built
C<emit()> method to produce a trace of the POD parsing events.

=head2 Test suite
The t/ directory has one test script for each emitter class, except that
a single script tests both pod5 and pod6 emitters to reuse the documents.
The t/ directory also contains a document featuring each pod construct.
Each emitter test script should handle each document, therefore
$possible_tests = ( $test_scripts + 1 ) * $documents. The + 1 is because
the pod test script performs each test twice.

=head2 Round trip testing
Start with a document in one format, for example POD6. Use a translator
to generate another format such as POD5. Then use another translator to
convert the translated document back again. Compare the original and the
twice translated versions. Improve the translators (and the document)
until there are no (significant) differences.

To avoid lossy conversions the documents would only use features
available in both formats.
Therefore use different documents to test different round trips (text,
Unix man page, xhtml, docbook etc).

Success rate may improve by adding a third translation step, to the
non pod format a second time.
The outputs of the first and third translations should be identical.

=head2 Testing Coverage
General L<Helmuth von Moltke|http://en.wikipedia.org/wiki/Helmuth_von_Moltke_the_Elder>
said (translated) "no plan survives contact with the enemy".
For Pod::Parser the battle is with unexpected constructs in POD that
anyone may have written.
The fact that Pod::Parser and its emitters can pass a fixed number of
tests does not prove enough.
Certain documents do fool Pod::Parser, and it can be improved.
Everyone can help by emailing the shortest possible example of valid
misunderstood POD to the address below.
The maintainer(s) will verify the POD validity, try to alter Pod::Parser
to handle it correctly and then expand the test suite to ensure that the
problem never returns.

The Pod::Parser documentation (this POD) should contain an example of
every kind of markup to try out parsing and rendering.

The following meaningless text broadens test coverage by mentioning the
inline formatting codes that do not occur elsewhere in this document:
A<undefined> B<basis> C<code should be able to
span lines> D<definition1|synonym1> D<definition2|synonym2a;synonym2b>
E<entity> F<undefined> G<undefined> H<undefined> I<important>
J<undefined> K<keyboard input> L<http://link.url.com> M<module:content>
N<note not rendered inline> O<undefined> P<file:other.pod> Q<undefined>
R<replaceable metasyntax> S<space   preserving   text>
T<terminal output> U<unusual should be underlined>
V<verbatim does not process formatting codes> W<undefined>
X<index entry|entry1,subentry1;entry2,subentry2> Y<undefined>
Z<zero-width comment never rendered>

=head1 TODO
Complete support for the full =marker set.

Handle =config and all configuration pair notations.

Manage allowed formatting codes dynamically, to support for example
=begin code
    =config C < > :allow<E I>
=end code

A handler could be added to the default case in every given { } block
to detect unhandled POD.

Calls to C<self.content()> should pass a structure of format
requirements, not a reference to a block.

Recover gracefully and issue warnings when parsing invalid or badly
formed POD.

Or.. make a pod6checker with helpful diagnostics.

Verify parser and emitters on Pugs, Mildew, Elf etc too.

=head1 BUGS
Formatting codes at the beginning or end of POD lines are not padded
with a space when word wrapped.

Formatting code L<Pod::to::whatever> parses as scheme=>Pod :(

Nested formatting codes cause internal errors.

Enums are not (yet) available for properties. A fails, B passes and C fails:
=begin code
 class A {                 has $.e is rw; method m {   $.e = 1; say $.e; }; }; A.m; # fails
 class B { enum E <X Y Z>;                method m { my $e = Y; say  $e; }; }; B.m; # works
 class C { enum E <X Y Z>; has $.e is rw; method m {   $.e = Y; say $.e; }; }; C.m; # fails
=end code

Long or complex documents randomly suffer segmentation faults.

=head2 Rakudo dependencies
Tested OK with Parrot/Rakudo revisions 36097-37432 (as at 2009-03-15).

=head1 SEE ALSO
The Makefile in the Pod::Parser directory for build and test procedures.
L<http://perlcabal.org/syn/S26.html>
L<doc:Pod::to::man> L<doc:Pod::to::xhtml> L<doc:Pod::to::wordcount>
L<doc:perl6pod> L<doc:perl6style> The Perl 5 L<Pod::Parser>.

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @autoexec.demon.nl).

=head1 ACKNOWLEDGEMENTS
Many thanks to (in order of contribution):
Larry Wall for perl, and for letting POD be 'manpages for dummies'.
Damian Conway, for the Perl 6 POD
specification L<S26|http://perlcabal.org/syn/S26.html>.
The Rakudo developers led by Patrick Michaud and all those helpful
people on #perl6.
The Parrot developers led by chromatic and all those clever people on
#parrot.
Most recently, the "November" Wiki engine developers led by Carl Mäsak++
and Johan Viklund++, for illuminating the power and practical use of
Perl 6 regex and grammar definitions.

=end pod

