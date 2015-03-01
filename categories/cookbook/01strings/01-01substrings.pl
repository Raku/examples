use v6;

=begin pod
=head1 Substrings

You want to access or modify a portion of a string, not the whole thing.

=end pod

my ($string, $offset, $count) = ('Pugs is da bomb', 2, 5);
say $string.substr($offset, $count);
say $string.substr($offset);

# want to replace everything but the first two letters with the string
# "gilism ain't for wimps"
# this code works in Perl 5, but not in Perl 6
# substr($string, $offset) = "gilism ain't for wimps";
# say $string;
$string = $string.substr(0, $offset) ~ "gilism ain't for wimps";
say $string;

# vim: expandtab shiftwidth=4 ft=perl6
