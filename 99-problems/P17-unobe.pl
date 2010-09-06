use v6;

# Specification:
# P17 (*) Split a list into two parts; the length of the first part is given.
#   Do not use any predefined predicates.
# Example:
# > say bisect(<a b c d e f g h i k>,3).perl
# (["a", "b", "c"], ["d", "e", "f", "g", "h", "i", "k"])


my @l = <a b c d e f g h i k>;
sub prob17(@in, $n) {
    if @in.end < $n { return @in }
    else {
        my $beg = [gather { for 0...$n-1 { take @in[$_] } }];
        my $end = [gather { for $n...@in.end  { take @in[$_] } }];
        return ($beg, $end);
    }
}
say @l.perl;
say prob17(@l, 3).perl;
