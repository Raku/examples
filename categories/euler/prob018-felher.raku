use v6;

=begin pod

=TITLE Maximum path sum I

=AUTHOR Felix Herrmann

L<https://projecteuler.net/problem=18>

By starting at the top of the triangle below and moving to adjacent numbers
on the row below, the maximum total from top to bottom is 23.

=begin code :allow<B>
    B<3>
    B<7> 4
    2 B<4> 6
    8 5 B<9> 3
=end code

That is, 3 + 7 + 4 + 9 = 23.

Find the maximum total from top to bottom of the triangle below:

    75
    95 64
    17 47 82
    18 35 87 10
    20 04 82 47 65
    19 01 23 75 03 34
    88 02 77 73 07 63 67
    99 65 04 28 06 16 70 92
    41 41 26 56 83 40 80 70 33
    41 48 72 33 47 32 37 16 94 29
    53 71 44 65 25 43 91 52 97 51 14
    70 11 33 28 77 73 17 78 39 68 17 57
    91 71 52 38 17 14 91 43 58 50 27 29 48
    63 66 04 68 89 53 67 30 73 16 69 87 40 31
    04 62 98 27 23 09 70 98 73 93 38 53 60 04 23

NOTE: As there are only 16384 routes, it is possible to solve this problem
by trying every route. However, Problem 67, is the same challenge with a
triangle containing one-hundred rows; it cannot be solved by brute force,
and requires a clever method! ;o)

=end pod

my $triangle =
    '75
    95 64
    17 47 82
    18 35 87 10
    20 04 82 47 65
    19 01 23 75 03 34
    88 02 77 73 07 63 67
    99 65 04 28 06 16 70 92
    41 41 26 56 83 40 80 70 33
    41 48 72 33 47 32 37 16 94 29
    53 71 44 65 25 43 91 52 97 51 14
    70 11 33 28 77 73 17 78 39 68 17 57
    91 71 52 38 17 14 91 43 58 50 27 29 48
    63 66 04 68 89 53 67 30 73 16 69 87 40 31
    04 62 98 27 23 09 70 98 73 93 38 53 60 04 23';

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
