use v6;

say [+] (1..^1000).grep: { !($_ % (3&5)) };

# vim: expandtab shiftwidth=4 ft=perl6
