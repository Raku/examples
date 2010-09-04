use v6;

sub runlength (@a) {
    gather while @a.elems {
        my $val = @a.shift;
        my $num = 1;
        while @a[0] ~~ $val { @a.shift; $num++; }
        take [$num,$val];
    }
}

my @l = <a a a a b c c a a d e e e e>;

say ~@l;
runlength(@l).perl.say;


# vim:ft=perl6
