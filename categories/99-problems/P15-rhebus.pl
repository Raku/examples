use v6;

=begin pod

=TITLE P15 - Replicate the elements of a list a given number of times.

=AUTHOR Philip Potter

=head1 Specification

    P15 (**) Replicate the elements of a list a given number of times.

=head1 Example

    > say ~repli <a b c>,3;
    a a a b b b c c c

=end pod

sub repli(@l,$n) {
    return @l.map({$_ xx $n});
}

say ~repli <a b c>,3;

# vim: expandtab shiftwidth=4 ft=perl6
