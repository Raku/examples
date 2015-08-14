use v6;

=begin pod

=TITLE Number Rotations

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=168>

Consider the number 142857. We can right-rotate this number by moving the
last digit (7) to the front of it, giving us 714285.  It can be verified
that 714285=5×142857.  This demonstrates an unusual property of 142857: it
is a divisor of its right-rotation.

Find the last 5 digits of the sum of all integers n, 10 < n < 10^100, that
have this property.

=end pod

sub MAIN(Bool :$verbose = False) {
    my $sum = 0;
    # $multiplier is "d"
    for 1 .. 9 -> $multiplier {
        for 1 .. 99 -> $L {
            # $digit is m.
            for 1 .. 9 -> $digit {
                my $n = (((10 ** $L - $multiplier)*$digit)/(10*$multiplier - 1));

                my $number_to_check = $n * 10 + $digit;
                if ($n.chars() == $L and ($multiplier * $number_to_check
                        == $n + $digit * 10 ** $L)) {
                    print "Found $number_to_check\n" if $verbose;
                    $sum += $number_to_check;
                    print "Sum = $sum\n" if $verbose;
                }
            }
        }
    }

    if $verbose {
        say "Last 5 digits of the final sum are: ", "$sum".substr(*-5);
    }
    else {
        say "$sum".substr(*-5);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
