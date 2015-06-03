use v6;

=begin pod

=TITLE Pandigital multiples

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=38>

Take the number 192 and multiply it by each of 1, 2, and 3:

192 × 1 = 192
192 × 2 = 384
192 × 3 = 576

By concatenating each product we get the 1 to 9 pandigital,
192384576. We will call 192384576 the concatenated product of 192 and
(1,2,3)

The same can be achieved by starting with 9 and multiplying by 1, 2,
3, 4, and 5, giving the pandigital, 918273645, which is the
concatenated product of 9 and (1,2,3,4,5).

What is the largest 1 to 9 pandigital 9-digit number that can be
formed as the concatenated product of an integer with (1,2, ... , n)
where n > 1?

=end pod

sub concat-product($x, $n) {
    + [~] do for 1...$n { $x * $_ }
}

sub is-pandigital(Int $n is copy) {
    return unless 123456789 <= $n <= 987654321;
    my $x = 0;
    loop ( ; $n != 0 ; $n div=10) {
        my $d = $n mod 10;
        $x += $d * 10 ** (9 - $d);
    }
    $x == 123456789;
}

say max gather for 1 .. 9999 -> $x {
    next if $x !~~ /^^9/;
    for 2 .. 5 -> $n {
        my $l = concat-product $x, $n;
        take $l if is-pandigital $l;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
