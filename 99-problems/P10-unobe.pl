use v6;

# Specification:
#   P10 (*) Run-length encoding of a list.
#       Use the result of problem P09 to implement the so-called run-length
#       encoding data compression method. Consecutive duplicates of elements
#       are encoded as arrays [N, E] where N is the number of duplicates of the
#       element E.
# Example:
# > encode(<a a a a b c c a a d e e e e>).perl.say
# [[4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"]]


my @l = <a a a a b c c a a d e e e e>;
sub prob10 (@in) {
    return gather loop {
        last if !@in.elems;
        my $val = @in[0];
        take [
            gather {
                loop {
                    last if !@in.elems;
                    @in[0] ~~ $val ?? take(shift @in) !! last
                };
            }.elems, $val
        ];
    };
}
say ~@l;
say prob10(@l).perl;

