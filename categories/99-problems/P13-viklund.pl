use v6;

=begin pod

=TITLE P13 - Run-length encoding of a list (direct solution).

=AUTHOR Johan Viklund

=head1 Specification

   P13 (**) Run-length encoding of a list (direct solution).
       Implement the so-called run-length encoding data compression method
       directly. I.e. don't explicitly create the sublists containing the
       duplicates, as in problem P09, but only count them. As in problem P11,
       simplify the result list by replacing the singletons [1,X] by X.

=head1 Example

    > encode_direct(<a a a a b c c a a d e e e e>).perl.say
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])

=end pod

multi infix:<compress> ( $a, $b ) { $a ~~ $b ?? [$[2, $a]] !! [ $[1, $a], $[1, $b] ] }
multi infix:<compress> ( @a, $b ) {
    
    if @a[*-1][1] ~~ $b {
        @a[*-1][0]++;
        return @a;
    } else {
        return [ |@a, [1, $b] ];
    }
}

say ([compress] <a a a a b c c a a d e e e e>).perl;

# vim: expandtab shiftwidth=4 ft=perl6
