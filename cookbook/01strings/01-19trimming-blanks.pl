use v6;

=begin pod
=head1 Trimming blanks from a string

=end pod

# XXX What are "blanks"? How many kinds of unicode whitespace are matched by
# this thing? What about non-breaking whitespace? And maybe make clear that
# we're only doing something about leading and trailing "blanks".

# To trim a string
# (Basing this on discussion at http://tinyurl.com/4xjnh)
my $string = "abc\n";
$string = $string.trim;
$string = trim($string);
say $string;

# To remove the last character from a string:
chop($string);
$string.chop;
say $string;
# XXX Maybe note that this is just short for a substr call?
