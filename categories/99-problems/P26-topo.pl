use v6;

=begin pod

=TITLE P26 - Generate the combinations of C<k> distinct objects chosen from the C<n> elements of a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say c(2, <a b c d e>);
    a b a c a d b c b d c d

=end pod

sub c(Int $n, [ $x, *@xs ])
{
    if $n  == 0  { return [] }
    if @xs ~~ () { return () }

    map({ [ $x, @^others ] }, c($n - 1, @xs)), c($n, @xs);
}

say c(3, <a b c d e f g h i j k l>);

# vim: expandtab shiftwidth=4 ft=perl6
