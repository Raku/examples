#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Convert to/from Roman Numerals

=AUTHOR Rosetta Code

You want to convert to/from Roman Numerals

=end pod

say to-roman(2015); # ==> MMXV

say from-roman('MMXV'); # ==> 2015

multi sub to-roman (0) { '' }
multi sub to-roman (Int $n) {
    my %symbols =
    1 => "I", 5 => "V", 10 => "X", 50 => "L", 100 => "C",
    500 => "D", 1_000 => "M";

    my @subtractors =
    1_000, 100,  500, 100,  100, 10,  50, 10,  10, 1,  5, 1,  1, 0;

    for @subtractors -> $cut, $minus {
        $n >= $cut
            and return %symbols{$cut} ~ to-roman($n - $cut);
        $n >= $cut - $minus
            and return %symbols{$minus} ~ to-roman($n + $minus);
    }
}

sub from-roman($r) {
    [+] gather $r.uc ~~ /
        ^
        [
        | M  { take 1000 }
        | CM { take 900 }
        | D  { take 500 }
        | CD { take 400 }
        | C  { take 100 }
        | XC { take 90 }
        | L  { take 50 }
        | XL { take 40 }
        | X  { take 10 }
        | IX { take 9 }
        | V  { take 5 }
        | IV { take 4 }
        | I  { take 1 }
        ]+
        $
    /;
}

# vim: expandtab shiftwidth=4 ft=perl6
