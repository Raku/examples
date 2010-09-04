use v6;

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
