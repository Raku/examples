use v6;

=begin pod

=TITLE P14 - Duplicate the elements of a list.

=AUTHOR Scott Penrose

=head1 Specification

   P14 (*) Duplicate the elements of a list.

=head1 Example

    > say ~dupli(<a b c c d>);
    a a b b c c c c d d

=end pod

sub dupli(@l) {
    return @l.map({$_, $_});
}
say ~dupli(<a b c c d>);

# vim: expandtab shiftwidth=4 ft=perl6
