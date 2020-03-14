use v6;

=begin pod

=TITLE P19 - Rotate a list C<n> places to the left.

=AUTHOR Ryan Connelly

=head1 Example

    > say rotate(<a b c d e f g>.list, 3).perl;
    Array.new("d", "e", "f", "g", "a", "b", "c")

=end pod

sub rotate(@list is copy, $places is copy)
{
    $places = @list.elems + $places if $places < 0;

    for ^$places {
        @list.push: @list.shift;
    }

    @list
}

say rotate(<a b c d e f g>.list, 3).perl;
say rotate(<a b c d e f g>.list, -3).perl;

# vim: expandtab shiftwidth=4 ft=perl6
