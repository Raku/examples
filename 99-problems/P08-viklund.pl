use v6;

# Specification:
#   P08 (**) Eliminate consecutive duplicates of list elements.
#       If a list contains repeated elements they should be replaced with a
#       single copy of the element. The order of the elements should not be
#       changed.
#
# Example:
# > say ~compress(<a a a a b c c a a d e e e e>)
# a b c a d e


# We define an infix operator called 'compress' such that:
#        'a' compress 'a' gives 'a'
#        'a' compress 'b' gives ['a','b']
#   [@a,'a'] compress 'a' gives [ @a,'a']
#   [@a,'a'] compress 'b' gives [ @a,'a','b']
#
# FIXME "our" is needed under rakudo as of 2010-09-04
our multi infix:<compress> ( $a, $b ) { $a      ~~ $b ?? $a !! [ $a, $b ] }
our multi infix:<compress> ( @a, $b ) { @a[*-1] ~~ $b ?? @a !! [ @a, $b ] }

# Now all we need to do is split our array up and insert compress.
#   given <a a b c c d> we want:
#   'a' compress 'a' compress 'b' compress 'c' compress 'c' compress 'd'
# The reduce metaoperator does exactly this. Example:
#   [+] (1,2,3,4,5) == 1 + 2 + 3 + 4 + 5 == 15
#   [~] <a b c d e> eq 'a' ~ 'b' ~ 'c' ~ 'd' ~ 'e' eq 'abcde' 

say ([compress] <a a a a b c c a a d e e e e>).perl;

# vim:ft=perl6
