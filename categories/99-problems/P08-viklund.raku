use v6;

=begin pod

=TITLE P08 - Eliminate consecutive duplicates of list elements.

=AUTHOR Johan Viklund

We define an infix operator called 'compress' such that:

       'a' compress 'a' gives 'a'
       'a' compress 'b' gives ('a','b')
  (@a,'a') compress 'a' gives ( @a,'a')
  (@a,'a') compress 'b' gives ( @a,'a','b')

Now all we need to do is split our array up and insert compress.

  given <a a b c c d> we want:
  'a' compress 'a' compress 'b' compress 'c' compress 'c' compress 'd'

The reduce metaoperator does exactly this. For example:

  [+] (1,2,3,4,5) == 1 + 2 + 3 + 4 + 5 == 15
  [~] <a b c d e> eq 'a' ~ 'b' ~ 'c' ~ 'd' ~ 'e' eq 'abcde'

=head1 Specification

   P08 (**) Eliminate consecutive duplicates of list elements.
       If a list contains repeated elements they should be replaced with a
       single copy of the element. The order of the elements should not be
       changed.

=head1 Example

    > say [compress] <a a a a b c c a a d e e e e>
    a b c a d e

=end pod

multi infix:<compress> ( $a, $b ) { $a      ~~ $b ?? $a !! ( $a, $b ) }
multi infix:<compress> ( @a, $b ) { @a[*-1] ~~ $b ?? @a !! ( @a, $b ).flat }

say ([compress] <a a a a b c c a a d e e e e>).perl;

# vim: expandtab shiftwidth=4 ft=perl6
