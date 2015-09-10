use v6;

=begin pod

=TITLE Maximum path sum II

=AUTHOR Felix Herrmann

L<https://projecteuler.net/problem=67>

By starting at the top of the triangle below and moving to adjacent numbers
on the row below, the maximum total from top to bottom is 23.

=begin code :allow<B>
   B<3>
  B<7> 4
 2 B<4> 6
8 5 B<9> 3
=end code

That is, 3 + 7 + 4 + 9 = 23.

Find the maximum total from top to bottom in triangle.txt, a 15K text file
containing a triangle with one-hundred rows.

NOTE: This is a much more difficult version of Problem 18. It is not
possible to try every route to solve this problem, as there are 299
altogether! If you could check one trillion (1012) routes every second it
would take over twenty billion years to check them all. There is an
efficient algorithm to solve it. ;o)

=end pod

my $triangle = slurp($*SPEC.catdir($*PROGRAM-NAME.IO.dirname, '/triangle.txt'));
my @lines = string-to-array($triangle).reverse;

# reduce the triangle by adding up the lines until only one line with one
# element is left; then print it.
say "{@lines.reduce: &add-maxima}";

# this function assumes the shorter and longer array to be consecutive lines
# in an reversed triangle. It then adds each of the maxima of consecutive fields
# of the longer array to their shared diagonal neighbour in the shorter array.
sub add-maxima(@longer, @shorter is copy) {
    for 0 .. @longer - 2 -> $i {
        @shorter[$i] += max @longer[$i], @longer[$i + 1];
    }
    return @shorter;
}

sub string-to-array($string) {
    my @lines = $string.lines;
    @lines .= map(-> $line { $line.comb(/\d+/).item });
}

# vim: expandtab shiftwidth=4 ft=perl6
