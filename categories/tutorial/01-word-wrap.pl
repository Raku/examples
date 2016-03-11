#!/usr/bin/env perl6

=begin pod

=TITLE Word-wrap paragraphs to a given length

=AUTHOR Scott Penrose

=end pod

use v6;

sub MAIN($input-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "lorem.txt")) {
    for $input-file.IO.lines {
        print-wrapped(.words);
    }
}

# Print words, new line at word wrap, new line for paragraph
sub print-wrapped (@words, $wrap-at = 50 ) {
    my $column = 0;
    for @words -> $word {
        my $word-length = $word.chars;
        if $column + $word-length > $wrap-at {
            print "\n";
            $column = 0;
        }
        unless $column = 0 {
            print ' ';
            $column++ ;
        }
        print $word;
        $column += $word-length;
    }
    print "\n";
}

# vim: expandtab shiftwidth=4 ft=perl6
