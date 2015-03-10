#!perl6

use v6;

say [+] gather {
  for (1..999) {
    take $_ if $_ % 3 == 0 || $_ % 5 == 0;
  }
}

# vim: expandtab shiftwidth=4 ft=perl6
