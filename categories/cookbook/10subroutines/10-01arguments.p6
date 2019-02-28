#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Accessing subroutine arguments

=AUTHOR stmuk

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
    for %flags.sort(*.key)>>.kv -> ($key, $value) {
        say "$key => $value";
    }
}
my @stuff = ('array', 'elements');
my %flags = (hash => 'elements', are => 'pairs');
whole(@stuff, %flags);

sub optional ($required, $optional?) {
    my $second_arg = $optional // 'Told you it was optional!';
    say $required;
    say $second_arg;
}

optional('this');
optional('this', 'that');

sub named_params ($first, :$second, :$third) {
    say $first, $second, $third;
}

named_params(1, second => 2, third => 3);
named_params(1, :second(2), :third(3));

sub transport ($planet, *@names) {
    say "Transporting to $planet:";
    for @names -> $name {
        say "    $name";
    }
}
transport('Magrathea', 'Arthur', 'Ford', 'Ovid');

sub typed (Int $val) {
    say "You gave me the integer: " ~ $val;
}
typed(3);

# vim: expandtab shiftwidth=4 ft=perl6
