use v6;

=begin pod

=TITLE P10 - Run-length encoding of a list.

=AUTHOR Scott Penrose

=head1 Specification

   P10 (*) Run-length encoding of a list.
       Use the result of problem P09 to implement the so-called run-length
       encoding data compression method. Consecutive duplicates of elements
       are encoded as arrays [N, E] where N is the number of duplicates of the
       element E.

=head1 Example

    > encode(<a a a a b c c a a d e e e e>).perl.say
    [[4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"]]

=end pod

my @l = <a a a a b c c a a d e e e e>;
sub packit (@in) {
    my @out;
    my $last = shift @in;
    my $count = 1;
    for @in -> $t {
        if ($last eq $t) {
            $count++;
        }
        else {
            push @out, $[$count, $last];
            $last = $t;
            $count = 1;
        }
    }
    push @out, $[$count, $last];
    return @out;
}
say ~@l;
say packit(@l).perl;

# vim: expandtab shiftwidth=4 ft=perl6
