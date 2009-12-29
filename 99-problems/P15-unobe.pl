# Replicate the elements of a list a given number of times.
# Example:
# * (repli '(a b c) 3)
#   (A A A B B B C C C)
my @l = <a b c>;
sub prob15(@in, $n) {
    gather { for 0 ... @in.end -> $i { for 1 ... $n { take @in[$i] } } }
}
say @l.perl;
say prob15(@l, 3).perl;
