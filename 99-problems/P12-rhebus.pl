use v6;

# Specification:
#   P12 (**) Decode a run-length encoded list.
#       Given a run-length code list generated as specified in problem P11.
#       Construct its uncompressed version.


# We use the following constructs:
#   .map  
#         creates a modified sequence by applying the block to each element in
#         turn. Within the block the element is represented by $_
#   when expr { block }
#         roughly equivalent to: if $_ ~~ expr { block; next }
#   xx    
#         list repetition operator. (<1 2> xx 3) is the same as <1 2 1 2 1 2>
#   .flat 
#         flattens a sequence. The map has constructed a sequence of Parcels:
#         (('a','a','a','a'),'b',('c','c'))
#         This sequence may be presented flat or hierarchical depending on
#         context. We use .flat to force a flattened context.

sub prob12 (@a) {
    my $l = @a.map: {
        when Array { $_[1] xx $_[0] }
        $_
    }
    return $l.flat;
}

my @l = ([4,'a'],'b',[2,'c'],[2,'a'],'d',[4,'e']);

say ~@l;
prob12(@l).perl.say;

# vim:filetype=perl6
