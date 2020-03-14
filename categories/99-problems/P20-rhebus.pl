use v6;

=begin pod

=TITLE P20 - Remove the K'th element from a list.

=AUTHOR Philip Potter

=head1 Specification

    P20 (*) Remove the K'th element from a list.

    You may choose to mutate the array in-place or create a new sequence and
    return it.

=head1 Examples

Example 1 (mutating in-place):

    > my @l = <a b c d>;
    > remove-at(@l,2);
    > say ~@l;
    a c d

Example 2 (returning a copy):

    > say ~remove-at-copy(<a b c d>, 2);
    a c d

=end pod

# a. Simple version, in place
#       @array  - your "@array" must always use "@" - even for a single element
#       .splice - Your array is also an object, you can call the method .splice
#               - offset - where to remove (starting 0)
#               - length - how many to remove
#               - What to add in its place (nothing in this case, see P21-scottp.pl
#                                           for an example of adding)
my @array = <a b c d>;
@array.splice(1, 1);
say ~@array;

# b. Using a sub in-place
#       @arr is declared with "is rw", so if you splice on the actual array, not a
#       copy of it, you will mutate the caller's copy.
sub remove-at (@arr, Int $pos) {
    @arr.splice($pos - 1, 1);
    return;
}

my @array2 = <a b c d>;

remove-at(@array2, 2);
say ~@array2;

# Alternatively, call using pseudomethod syntax:

@array2.&remove-at(2);
say ~@array2;

# c. Using a sub, returning a copy
#    This time we must copy the sequence and mutate that
#     -- easy-peasy with the "is copy" declaration
sub remove-at-copy(@list is copy, $pos) {
    @list.splice($pos-1, 1);
    return @list;
}

say ~remove-at-copy(<a b c d>, 2);

# and again pseudomethod syntax
say ~<a b c d>.&remove-at-copy(2);

# vim: expandtab shiftwidth=4 ft=perl6
