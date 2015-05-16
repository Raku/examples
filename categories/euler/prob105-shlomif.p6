use v6;

sub is_special_sum_set(@A)
{
    my $recurse;

    $recurse = sub ($i, $B_sum, $B_count, $C_sum, $C_count) {

        if $i == @A
        {
            if (
                (!$B_count) || (!$C_count)
                    ||
            (
                ($B_sum != $C_sum)
                    &&
                (($B_count > $C_count) ?? ($B_sum > $C_sum) !! True)
                    &&
                (($C_count > $B_count) ?? ($C_sum > $B_sum) !! True)
            )
            )
            {
                # Everything is OK.
                return;
            }
            else
            {
                # Incorrect.
                X::AdHoc.new(:payload<foo>).throw;
            }
        }

        $recurse(
            $i+1, $B_sum+@A[$i], $B_count+1, $C_sum, $C_count
        );
        $recurse(
            $i+1, $B_sum, $B_count, $C_sum+@A[$i], $C_count+1
        );
        $recurse(
            $i+1, $B_sum, $B_count, $C_sum, $C_count
        );

        return;
    };

    my $ret = True;
    $recurse(0, 0, 0, 0, 0);

    CATCH {
        when X::AdHoc { $ret = False; }
    }

    return $ret;
}

sub MAIN(:$verbose = False) {
    my $total_sum = 0;

    for 'sets.txt'.IO.lines -> $l
    {
	say "Processing $l" if $verbose;
	my @set = $l.split(',');
	if (is_special_sum_set(@set))
	{
	    $total_sum += ([+] @set);
	}
    }
    $verbose ?? say "Total Sum = $total_sum" !! say $total_sum;
}
