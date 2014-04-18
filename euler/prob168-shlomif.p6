use v6;

my $sum = 0;
# $multiplier is "d"
for 1 .. 9 -> $multiplier
{
    for 1 .. 99 -> $L
    {
        # $digit is m.
        for 1 .. 9 -> $digit
        {
            my $n = (((10 ** $L - $multiplier)*$digit)/(10*$multiplier - 1));

            my $number_to_check = $n * 10 + $digit;
            if ($n.chars() == $L and ($multiplier * $number_to_check
                    == $n + $digit * 10 ** $L))
            {
                print "Found $number_to_check\n";
                $sum += $number_to_check;
                print "Sum = $sum\n";
            }
        }
    }
}

print "Last 5 digits of the final sum are: ", "$sum".substr(*-5), "\n";
