use v6;

sub _splat(@t) {
    for @t -> $t {
        if $t ~~ Array { _splat($t) }
        else           { take $t }
    }
}

sub splat (@t) { gather _splat(@t) }

splat(['a', ['b',['c','d'], 'e']]).perl.say;

# vim:ft=perl6
