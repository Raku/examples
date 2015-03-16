#
# DON'T TRY  EXECUTING THIS SCRIPT WITH RAKUDO 2010.08 OR OLDER!
# Because of memory leak in these versions, this code eats tens of gigabytes of RAM
#

my $palindromNumbersSum = 0;
loop (my $i = 1; $i <= 999999; $i+=2) {
    if ( ($i.flip == $i) && (sprintf('%b',$i).flip == sprintf('%b',$i)) ) {
        $palindromNumbersSum += $i;
    }
    say "Checked $i of 999999 numbers" unless $i % 99999;
}
say "Number of double-base palindromes: $palindromNumbersSum";

# vim: expandtab shiftwidth=4 ft=perl6
