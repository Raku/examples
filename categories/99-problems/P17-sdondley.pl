use v6;

=begin pod

=TITLE P17 - Split a list into two parts; the length of the first part is given.

=AUTHOR Ryan Connelly

=head1 Example

    > say split-list(('a' xx 10).list, 8).perl;
    (["a", "a", "a", "a", "a", "a", "a", "a"], ["a", "a"]).list

=head1 Notes

Rather than looping over every array elment which is wasteful especially for
large arrays, this solution returns two array slices from the original array.
In an edge case when the number of elements desired in the first returned array
is greater than or equal to the size of the original array, the original array
gets returned.

=end pod

sub bisect(@array, $num) {
    when @array.elems <= $num { @array };
    [ @array[0..^$num] ], [ @array[$num..*-1] ];
}

say bisect [1, 2, 3, 4, 5], 3;


# vim: expandtab shiftwidth=4 ft=perl6
