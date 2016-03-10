#!/usr/bin/env perl6

=begin pod

=TITLE Word-wrap paragraphs to a given length

=AUTHOR Scott Penrose

=end pod

use v6;

my $line_length = 50;

my $tempfile = open('lorem.txt', :r);
my $count = 0;
for $tempfile.lines {
    $count++;
    lines(words($_));
}

exit 0;

# Split a line into words (array)
sub words ($in) {
    return $in.split(/\s/);
}

# Print words, new line at word wrap, new line for paragraph
sub lines (@in) {
    my $length = 0;
    for @in -> $l {
        if ( ($length + $l.chars) < $line_length) {
            print $l ~ ' ';
            $length += $l.chars;
        }
        else {
            print "\n$l ";
            $length = $l.chars;
        }
    }
    say '';
}

# vim: expandtab shiftwidth=4 ft=perl6
