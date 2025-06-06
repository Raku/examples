use v6;

=begin pod

=TITLE P21 - Insert an element at a given position into a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say insert-at('alfa', <a b c d>, 2);
    a alfa b c d

=end pod

sub insert-at($elem, @list is copy, $place)
{
    @list.splice($place - 1, 0, $elem);

    @list
}

say "{insert-at('alfa', <a b c d>, 2)}";

# vim: expandtab shiftwidth=4 ft=perl6
