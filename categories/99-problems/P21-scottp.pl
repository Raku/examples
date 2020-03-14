use v6;

=begin pod

=TITLE P21 - Insert an element at a given position into an array.

=AUTHOR Scott Penrose

=head1 Specification

    P21 (*) Insert an element at a given position into an array.
            You may choose to mutate the array in-place or to create a new
            sequence and return it.

=head1 Examples

Example 1 (mutating in-place);

    > my @l = <a b c d>
    > insert_at('alfa',@l,2);
    > say ~@l;
    a alfa b c d

Example 2 (creating a copy):

    > say ~insert_at_copy('alfa', <a b c d>, 2);
    a alfa b c d

=end pod

# a. Simple version, in place
#       @array  - your "@array" must always use "@" - even for a single element
#       .splice - Your array is also an object, you can call the method .splice
#               - offset - where to add (starting 0)
#               - length - how many to replace (0 for insert)
#               - What to add
my @array = <a b c d>;
@array.splice(1, 0, 'alfa');
say ~@array;

# b. Using a sub in-place
#       $in, @arr, $pos - you can insert an array in the middle of your parameters
#       The array is like a reference, so if you splice on the actual array, not a
#       copy of it, you will mutate the caller's copy.
#   However if you modify the argument, you must declare it with "is rw" or
#   the compiler may complain at you.
sub insert_at ($in, @arr, $pos) {
    @arr.splice($pos - 1, 0, $in);
    return;
}

my @array2 = <a b c d>;

insert_at('alfa', @array2, 2);
say ~@array2;

# c. Using a sub, returning a copy
#    This time we must copy the sequence and mutate that
sub insert_at_copy($in, @list is copy, $pos) {
    @list.splice($pos-1, 0, $in);
    return @list;
}

say ~insert_at_copy('alfa', <a b c d>, 2);

# vim: expandtab shiftwidth=4 ft=perl6
