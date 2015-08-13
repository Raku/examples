use v6;

use lib 'lib';
use Test;

plan 6;

my @dependencies = qw{
    URI
    Pod::To::HTML
    LWP::Simple
    Algorithm::Soundex
    DBIish
    File::Temp
};

for @dependencies -> $dep {
    use-ok $dep, "$dep able to be use-d ok";
}

# vim: expandtab shiftwidth=4 ft=perl6
