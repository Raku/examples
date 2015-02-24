use v6;

my @result;

[1], -> @p { [0, @p Z+ @p, 0] } ... * \ # generate Pascal's triangle
==> (*[0..100])() \
==> map *.list \
==> grep * > 1_000_000 \
==> elems() \
==> @result;  # work around .say not yet handling feeds in Rakudo 2015.02
#==> say;
@result.say;

# vim: expandtab shiftwidth=4 ft=perl6
