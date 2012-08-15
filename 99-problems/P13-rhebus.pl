use v6;

# Specification:
#   P13 (**) Run-length encoding of a list (direct solution).
#       Implement the so-called run-length encoding data compression method
#       directly. I.e. don't explicitly create the sublists containing the
#       duplicates, as in problem P09, but only count them. As in problem P11,
#       simplify the result list by replacing the singletons [1,X] by X.
# Example:
# > encode_direct(<a a a a b c c a a d e e e e>).perl.say
# ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])


# We use gather as a loop modifier, to gather a list over all the loop
# iterations

sub runlength (@a) {
    gather {
        last if !@a.elems;

        my $val = @a.shift;
        my $num = 1;
        while @a[0] ~~ $val { @a.shift; $num++; }
        take $num == 1 ?? $val !! [$num,$val];
    }
}

my @l = <a a a a b c c a a d e e e e>;

say ~@l;
runlength(@l).perl.say;


# vim:ft=perl6
