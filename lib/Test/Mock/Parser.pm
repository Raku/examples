use v6;

role Test::Mock::Parser {
    has @!out is rw;
    # parse source lines from a text document instead of a file
    method parse( $text ) {
        my @lines = $text.split( "\n" );
        @!out = ();
        self.doc_beg( 'test' );
        for @lines -> Str $line { $!line = $line; self.parse_line; }
        self.doc_end;
        return @!out;
    }
    # capture output into array @.out for inspection
    method emit( $self: $text ) { push @!out, $text; }
}

=begin pod

=head1 AUTHOR
Carl Mäsak

=end pod
