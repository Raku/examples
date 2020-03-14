use v6;

=begin pod

=TITLE P15 - Replicate the elements of a list a given number of times.

=AUTHOR David Romano

=head1 Specification

   P15 (**) Replicate the elements of a list a given number of times.

=head1 Example

    > say prob15(<a b c>, 3);
    a a a b b b c c c

=end pod

my @l = <a b c>;
sub prob15(@in, $n) {
    gather { for 0 ... @in.end -> $i { for 1 ... $n { take @in[$i] } } }
}
say @l.perl;
say prob15(@l, 3).list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
