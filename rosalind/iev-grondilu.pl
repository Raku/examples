use v6;

given $*IN.get.split: " " {
    say 2 * [+]
    .[0],             # AA AA
    .[1],             # AA Aa
    .[2],             # AA aa
    (3/4 * .[3]),     # Aa Aa
    (1/2 * .[4]),     # Aa aa
    0,                # aa aa
    ;
}
# vim: ft=perl6
