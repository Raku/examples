use v6;

=begin pod

=TITLE Word-wrap paragraphs to a given length

=AUTHOR Scott Penrose

Uses a minimum number of lines algorithm based upon
L<https://en.wikipedia.org/wiki/Line_wrap_and_word_wrap#Minimum_number_of_lines>.

=end pod

sub MAIN($input-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "lorem.txt")) {
    for $input-file.IO.lines {
        print-wrapped(.words);
    }
}

my $space-width = 1;  # width of a space character

# Print words, new line at word wrap, new line for paragraph
sub print-wrapped (@words, $line-width = 60) {
    my $space-remaining = $line-width;
    my @words-in-line;
    for @words -> $word {
        my $word-length = $word.chars;
        if $word-length + $space-width > $space-remaining {
            @words-in-line.join(" ").say;
            $space-remaining = $line-width - $word-length;
            @words-in-line = ($word);
        }
        else {
            @words-in-line.push($word);
            $space-remaining = $space-remaining - ($word-length + $space-width);
        }
    }
    @words-in-line.join(" ").say;
}

# vim: expandtab shiftwidth=4 ft=perl6
