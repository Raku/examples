use v6;

=begin pod

=TITLE P23 - Extract a given number of randomly selected elements from a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say get-rand-elems(<a b c d e>, 3);
    c b a

=end pod

sub get-rand-elems(@list, $amount) {
    @list.pick($amount);
}

say "{get-rand-elems(<a b c d e>, 3)}";

# vim: expandtab shiftwidth=4 ft=perl6
