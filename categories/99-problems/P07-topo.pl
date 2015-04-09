use v6;

=begin pod

=TITLE P07 - Flatten a nested array structure.

=AUTHOR Ryan Connelly

=head1 Example

    > my @a = 1, 2, [3, 4], 5;
    > say flatten(@a).perl;
    (1, 2, 3, 4, 5).list

=end pod

sub flatten(@array)
{
    gather for @array -> $e
    {
        $e ~~ Array ?? take(flatten $e) !! take $e
    }
}

my @a = 1, 2, [3, 4], 5;

say @a.perl;
say 'Flattened:';
say flatten(@a).perl;

# vim: expandtab shiftwidth=4 ft=perl6
