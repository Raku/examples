use v6;

=begin pod

=TITLE P07 - Flatten a nested array structure.

=AUTHOR Orginally Ryan Connelly

=head1 Example

    > my @a = 1, 2, [3, 4], 5;
    > say @a.flat.list.perl
    (1, 2, 3, 4, 5)

=end pod

my @a := 1, 2, [3, 4], 5;

say @a.perl;
say 'Flattened:';
say @a.flat.list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
