use v6;

=begin pod

=TITLE P12 - Decode a run-length encoded list.

=AUTHOR Philip Potter

=head1 Specification

   P12 (**) Decode a run-length encoded list.
       Given a run-length code list generated as specified in problem P11.
       Construct its uncompressed version.

We use the following constructs:

=item .map

creates a modified sequence by applying the block to each element in
turn. Within the block the element is represented by $_

=item when expr { block }

roughly equivalent to: if $_ ~~ expr { block; next }

=item xx

list repetition operator. (<1 2> xx 3) is the same as <1 2 1 2 1 2>

=item .flat

flattens a sequence. The map has constructed a sequence of Parcels:

    (('a','a','a','a'),'b',('c','c'))

This sequence may be presented flat or hierarchical depending on
context. We use .flat to force a flattened context.

=head1 Example

    > say prob12(([4,'a'],'b',[2,'c'],[2,'a'],'d',[4,'e']))
    a a a a b c c a a d e e e e

=end pod

sub prob12 (@a) {
    my $l = @a.map: {
        when Array { $_[1] xx $_[0] }
        $_
    }
    return $l.flat;
}

my @l = ([4,'a'],'b',[2,'c'],[2,'a'],'d',[4,'e']);

say ~@l;
prob12(@l).list.perl.say;

# vim: expandtab shiftwidth=4 ft=perl6
