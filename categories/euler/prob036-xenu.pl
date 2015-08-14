use v6;

=begin pod

=TITLE Double-base palindromes

=AUTHOR xenu

L<https://projecteuler.net/problem=36>

The decimal number, 585 = 1001001001_2 (binary), is palindromic in both
bases.

Find the sum of all numbers, less than one million, which are palindromic in
base 10 and base 2.

(Please note that the palindromic number, in either base, may not include
leading zeros.)

=end pod

#
# DON'T TRY  EXECUTING THIS SCRIPT WITH RAKUDO 2010.08 OR OLDER!
# Because of memory leak in these versions, this code eats tens of gigabytes of RAM
#

sub MAIN(Bool :$verbose = False) {
    my $palindromNumbersSum = 0;
    loop (my $i = 1; $i <= 999999; $i+=2) {
        if ( ($i.flip == $i) && (sprintf('%b',$i).flip == sprintf('%b',$i)) ) {
            $palindromNumbersSum += $i;
        }
        if $verbose {
            say "Checked $i of 999999 numbers" unless $i % 99999;
        }

    }
    if $verbose {
        say "Number of double-base palindromes: $palindromNumbersSum";
    }
    else {
        say $palindromNumbersSum;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
