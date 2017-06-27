#!perl6

use v6;
use lib 'lib';

use Test;
use Test::META;

plan 1;

# That's it
meta-ok(:relaxed-name);


done-testing;
