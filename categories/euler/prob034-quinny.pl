use v6;

=begin pod

=TITLE Digit factorials

=AUTHOR Quinn Perfetto

L<https://projecteuler.net/problem=34>

145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.

Find the sum of all numbers which are equal to the sum of the factorial of their digits.

Note: as 1! = 1 and 2! = 2 are not sums they are not included.

=end pod

sub fact ($n) {
    [*] 1..$n;
}

sub factDigits ($n is copy) {
    [+] gather while $n > 0 {
        take fact $n % 10;
        $n div= 10;
    }
}

say [+] gather for 3...40586 {
    take $_ if factDigits($_) == $_
}

# vim: expandtab shiftwidth=4 ft=perl6
