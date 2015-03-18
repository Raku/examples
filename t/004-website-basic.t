use v6;

use lib 'lib';
use Test;

plan 2;

use-ok("Pod::Htmlify");

use Pod::Htmlify;

subtest {
    plan 1;

    ok(Website.new(), "A website object can be instantiated");

}, "Website object instantiation";

# vim: expandtab shiftwidth=4 ft=perl6
