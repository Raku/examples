use v6;

multi infix:<compress> ( $a, $b ) { $a ~~ $b ?? [[2, $a]] !! [ [1, $a], [1, $b] ] }
multi infix:<compress> ( @a, $b ) { 
    if @a[*-1][1] ~~ $b {
        @a[*-1][0]++;
        return @a;
    } else {
        return [ @a, [1, $b] ];
    }
}

say ([compress] <a a a a b c c a a d e e e e>).perl;

# vim:ft=perl6
