use v6;

[1], -> @p { [0, @p Z+ @p, 0] } ... * # generate Pascal's triangle
==> (*[0..100])()
==> map *.list
==> grep * > 1_000_000
==> elems()
==> say;
