#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Complex Numbers

=AUTHOR stmuk

Math with Complex Numbers

=end pod

say (3+5i) * (2-2i); # 16+4i

say sqrt(3+4i); # 2+1i

say abs(3+4i); # 5 (absolute value of complex number or "modulus")

say (3+4i).re; # 3 (real part)

say (3+4i).im; # 4 (imaginary part)

# vim: expandtab shiftwidth=4 ft=perl6
