use v6;

# "our" is needed for the current rakudo (2010-09-04)
# but as soon as it's not needed, it's better without
our multi infix:<compress> ( $a, $b ) { $a      ~~ $b ?? $a !! [ $a, $b ] }
our multi infix:<compress> ( @a, $b ) { @a[*-1] ~~ $b ?? @a !! [ @a, $b ] }

say ([compress] <a a a a b c c a a d e e e e>).perl;

# vim:ft=perl6
