# Split a list into two parts; the length of the first part is given.
# Example:
# * (split '(a b c d e f g h i k) 3)
# ( (A B C) (D E F G H I K))
my @l = <a b c d e f g h  i k>;
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
