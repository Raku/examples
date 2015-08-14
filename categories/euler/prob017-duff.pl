use v6;

=begin pod

=TITLE Number letter counts

=AUTHOR Jonathan Scott Duff

L<https://projecteuler.net/problem=17>

If the numbers 1 to 5 are written out in words: one, two, three, four, five,
then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.

If all the numbers from 1 to 1000 (one thousand) inclusive were written out
in words, how many letters would be used?

NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and
forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20
letters. The use of "and" when writing out numbers is in compliance with
British usage.

=end pod

# playing with multiple dispatch

multi sub num-to-word(0) { 'zero' }
multi sub num-to-word(1) { 'one' }
multi sub num-to-word(2) { 'two' }
multi sub num-to-word(3) { 'three' }
multi sub num-to-word(4) { 'four' }
multi sub num-to-word(5) { 'five' }
multi sub num-to-word(6) { 'six' }
multi sub num-to-word(7) { 'seven' }
multi sub num-to-word(8) { 'eight' }
multi sub num-to-word(9) { 'nine' }
multi sub num-to-word(10) { 'ten' }
multi sub num-to-word(11) { 'eleven' }
multi sub num-to-word(12) { 'twelve' }
multi sub num-to-word(13) { 'thirteen' }
multi sub num-to-word(14) { 'fourteen' }
multi sub num-to-word(15) { 'fifteen' }
multi sub num-to-word(16) { 'sixteen' }
multi sub num-to-word(17) { 'seventeen' }
multi sub num-to-word(18) { 'eighteen' }
multi sub num-to-word(19) { 'nineteen' }
multi sub num-to-word(20) { 'twenty' }
multi sub num-to-word(30) { 'thirty' }
multi sub num-to-word(40) { 'forty' }
multi sub num-to-word(50) { 'fifty' }
multi sub num-to-word(60) { 'sixty' }
multi sub num-to-word(70) { 'seventy' }
multi sub num-to-word(80) { 'eighty' }
multi sub num-to-word(90) { 'ninety' }

multi sub num-to-word($n is copy) {
    my (@words,$m);

    # The next three lines should be in a loop, but it's not really
    # worth it for just hundreds and thousands
    $m = truncate($n / 1000);
    @words.push: num-to-word($m), 'thousand' unless $m == 0;
    $n = $n % 1000;

    $m = truncate($n / 100);
    @words.push: num-to-word($m), 'hundred' unless $m == 0;
    $n = $n % 100;
    @words.push: 'and' if $m > 0 and $n > 0;

    if 0 < $n < 20 {
        @words.push: num-to-word($n);
    }
    else {
        my $r = $n % 10;
        $n = truncate($n / 10) * 10;
        @words.push: num-to-word($n) if $n > 0;
        @words.push: num-to-word($r) if $r > 0;
    }
    return @words.join;
}

my $max = @*ARGS[0] // 1000;
my $count = 0;
$count += num-to-word($_).chars for 1..$max;
say $count;

# vim: expandtab shiftwidth=4 ft=perl6
