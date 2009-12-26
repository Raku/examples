# Modify the result of problem P10 in such a way that if an element has no
# duplicates it is simply copied into the result list. Only elements with
# duplicates are transferred as (N E) lists.
#
#Example:
#* (pack '(a a a a b c c a a d e e e e))
# ((4 a) b (2 c) (2 a) d (4 e))

use v6;
my @l = <a a a a b c c a a d e e e e>;
sub prob11 (@in) {
    return gather loop {
        last if !@in.elems;
        my $val = @in[0];
        my @a = gather { loop { @in[0] ~~ $val ?? take shift @in !! last }; };
        take @a.end ?? [@a.elems, $val] !! $val;
    };
}
say ~@l;
say prob11(@l).perl;

