use v6;

=begin pod

=TITLE P08 - Eliminate consecutive duplicates of list elements.

=AUTHOR Eric Hodges

=head1 Specification

   P08 (**) Eliminate consecutive duplicates of list elements.
       If a list contains repeated elements they should be replaced with a
       single copy of the element. The order of the elements should not be
       changed.

=head1 Example

    > say ~compress(<a a a a b c c a a d e e e e>)
    a b c a d e

=end pod

die "Example doesn't yet work in Niecza" if $*VM ~~ 'niecza';

sub compress (@in) {
    my @return;
    my $last;
    for @in -> $i {
        FIRST { $last = '' }
        if ($i ne $last) {
            @return.push($i);
            $last = $i;
        }
    }
    return @return;
}

compress(<a a a a b c c a a d e e e e>).perl.say;

# vim: expandtab shiftwidth=4 ft=perl6
