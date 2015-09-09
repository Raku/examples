use v6;

=begin pod

=TITLE P16 (**) Drop every N'th element from a list.

=AUTHOR Edwin Pratomo

=head1 Specification

    P16 (**) Drop every N'th element from a list.

=head1 Example

    > say ~drop(<a b c d e f g h i k>, 3);
    a b d e g h k

=end pod

sub drop(@ary, $n) {
  gather for 1 .. @ary.elems -> $i { take @ary[$i - 1] if $i % $n }
}

drop(<A B C D E F G H I K>, 3).list.perl.say;

# vim: expandtab shiftwidth=4 ft=perl6
