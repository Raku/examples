use v6;

=begin pod

=TITLE P26 - Generate the combinations of C<k> distinct objects chosen from the C<n> elements of a list.

=AUTHOR Ryan Connelly

=head1 Example

    > say c(2, <a b c d e>);
    ((a b) (a c) (a d) (a e) (b c) (b d) (b e) (c d) (c e) (d e))

=end pod

multi sub c(0,      @xs)          { return ((),) }
multi sub c(Int $n, [])           { return ()    }
multi sub c(Int $n, [ $x, *@xs ]) {
    |map({($x, |@$_)}, c($n - 1, @xs)), |c($n, @xs);
}

my @combos = c(3, <a b c d e f g h i j k l>);
say @combos.elems;
say @combos[200..*];

# vim: expandtab shiftwidth=4 ft=perl6
