use v6;

use lib 'lib';
use Test;

plan 2;

use-ok "Perl6::Example";

use Perl6::Example;
ok(Example.new(), "An Example object can be instantiated");


# vim: expandtab shiftwidth=4 ft=perl6
