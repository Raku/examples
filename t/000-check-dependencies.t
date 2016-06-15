use v6;

use lib 'lib';
use Test;

my @dependencies = qw{
    Algorithm::Soundex
    DBIish
    File::Temp
    HTTP::Easy
    LWP::Simple
    Pod::To::HTML
    Terminal::ANSIColor
    Term::termios
    URI
    Web::Request
};

plan @dependencies.elems;

my @missing-deps;
for @dependencies -> $dep {
    my $use-able = use-ok $dep, "$dep able to be use-d ok";
    @missing-deps.push($dep) if not $use-able;
}

die "Please install the required dependencies:\n", @missing-deps.join("\n")
    if @missing-deps;

# vim: expandtab shiftwidth=4 ft=perl6
