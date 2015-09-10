use v6;

=begin pod

=TITLE P11 - Modified run-length encoding.

=AUTHOR David Romano

=head1 Specification

   P11 (*) Modified run-length encoding.
       Modify the result of problem P10 in such a way that if an element has
       no duplicates it is simply copied into the result list. Only elements
       with duplicates are transferred as (N E) lists.

=head1 Example

    > encode_modified(<a a a a b c c a a d e e e e>).perl.say
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])

=end pod

my @l = <a a a a b c c a a d e e e e>;
sub prob11 (@in) {
    return gather loop {
        last if !@in.elems;
        my $val = @in[0];
        my @a = gather loop {
            last if !@in.elems;
            @in[0] ~~ $val ?? take(shift @in) !! last
        };
        take @a.end ?? [@a.elems, $val] !! $val;
    };
}
say ~@l;
say prob11(@l).list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
