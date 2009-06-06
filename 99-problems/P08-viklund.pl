use v6;

multi infix:<compress> ( $a, $b ) { $a      ~~ $b ?? $a !! [ $a, $b ] }
multi infix:<compress> ( @a, $b ) { @a[*-1] ~~ $b ?? @a !! [ @a, $b ] }

say ([compress] <a a a a b c c a a d e e e e>).perl;

# vim:ft=perl6
