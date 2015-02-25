use v6;

=begin pod
=head1 Accessing subroutine arguments

You have written a function that takes arguments supplied by its caller and
you need to access those arguments

=end pod

sub perl5 {
    my ($x) = @_;
    say $x;
}

perl5('old-fashioned');

multi sub parameters ($foo) { say $foo }
multi sub parameters (:$foo) { say $foo }

parameters('some parameter');
parameters 'some parameter';
parameters foo => 'some parameter';
parameters :foo('some parameter');

sub whole (@names, %flags) {
    for @names -> $name {
        say $name;
    }
    for %flags.kv -> $key, $value {
        say "$key => $value";
    }
}
my @stuff = ('array', 'elements');
my %flags = (hash => 'elements', are => 'pairs');
whole([,] @stuff, %flags);

sub optional ($required, $optional?) {
    my $second_arg = $optional // 'Told you it was optional!';
    say $required;
    say $second_arg;
}

# XXX sub optional ($required, $optional = "Default value"), fyi
# XXX allows for undef to be passed.

optional('this');
optional('this', 'that');

sub named_params ($first, :$second, :$third) {
    say $first, $second, $third;
}

named_params(1, second => 2, third => 3);

# XXX Also, :first :second(2) :third(3)

sub transport ($planet, *@names) {
    say "Transporting to $planet:";
    for @names -> $name {
        say "\t$name";
    }
}
transport('Magrathea', 'Arthur', 'Ford', 'Ovid');

sub typed (Int $val) {
    say $val++;  # XXX $val is ro by default, so can't be ++'ed.
                 # XXX Besides, preinc is more interesting here
}
typed(3);

# vim: expandtab shiftwidth=4 ft=perl6
