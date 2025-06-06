use v6;

=begin pod

=TITLE Convergents of e

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=65>

The square root of 2 can be written as an infinite continued fraction.

        √2 = 1 +  1
                ______
                2 +  1
                   ______
                   2 +  1
                      ______
                      2 +  1
                         ______
                         2 + ...

The infinite continued fraction can be written, √2 = [1;(2)], (2) indicates
that 2 repeats ad infinitum. In a similar way, √23 = [4;(1,3,1,8)].

It turns out that the sequence of partial values of continued fractions for
square roots provide the best rational approximations. Let us consider the
convergents for √2.

          1 + 1
           ___              = 3/2
            2

              1 + 1
            _________       = 7/5
            2 + 1 / 2

        ....

Hence the sequence of the first ten convergents for √2 are: 1, 3/2, 7/5,
17/12, 41/29, 99/70, 239/169, 577/408, 1393/985, 3363/2378, ...

What is most surprising is that the important mathematical constant,
e = [2; 1,2,1, 1,4,1, 1,6,1 , ... , 1,2k,1, ...].

The first ten terms in the sequence of convergents for e are:
2, 3, 8/3, 11/4, 19/7, 87/32, 106/39, 193/71, 1264/465, 1457/536, ...

The sum of digits in the numerator of the 10th convergent is 1+4+5+7=17.

Find the sum of digits in the numerator of the 100th convergent of the
continued fraction for e.

=end pod

sub continued-fraction(@sequence, :$depth)  {
    my $x = @sequence.shift;
    return 1 if $depth == 1;
    $x + 1.FatRat /
        continued-fraction :depth($depth - 1), @sequence
}

my @e = lazy gather { take 2;  (1, $_, 1)».&take for 2,4 ... * };

say [+] continued-fraction(@e, depth => 100).numerator.comb;

# vim: expandtab shiftwidth=4 ft=perl6
