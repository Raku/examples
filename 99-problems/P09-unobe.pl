#Pack consecutive duplicates of list elements into sublists.
#If a list contains repeated elements they should be placed in separate sublists.
#
#Example:
#* (pack '(a a a a b c c a a d e e e e))
# ((A A A A) (B) (C C) (A A) (D) (E E E E))

use v6;
my @l = <a a a a b c c a a d e e e e>;
sub prob09 (@in) {
    return gather while @in.elems {
        my $val = @in[0];
    	take [gather while @in[0] ~~ $val { take shift @in }];
    }
}
say ~@l;
say prob09(@l).perl;

