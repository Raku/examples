use v6;

=begin pod

=TITLE Paper sheets of standard sizes: an expected-value problem

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=151>

A printing shop runs 16 batches (jobs) every week and each batch requires a
sheet of special colour-proofing paper of size A5.

Every Monday morning, the foreman opens a new envelope, containing a large
sheet of the special paper with size A1.

He proceeds to cut it in half, thus getting two sheets of size A2. Then he
cuts one of them in half to get two sheets of size A3 and so on until he
obtains the A5-size sheet needed for the first batch of the week.

All the unused sheets are placed back in the envelope.

At the beginning of each subsequent batch, he takes from the envelope one
sheet of paper at random. If it is of size A5, he uses it. If it is larger,
he repeats the 'cut-in-half' procedure until he has what he needs and any
remaining sheets are always placed back in the envelope.

Excluding the first and last batch of the week, find the expected number of
times (during each week) that the foreman finds a single sheet of paper in
the envelope.

Give your answer rounded to six decimal places using the format x.xxxxxx.

=end pod

my $sum = 0;

# rec is short for "recurse".
# $n is numerator ; $d is denominator
sub rec($n, $d, @counts, $result)
{
    my $cnt = [+] @counts;
    if $cnt == 0
    {
        $sum += $n * $result / $d;
    }
    else
    {
        my $new_r = $result + ($cnt == 1);
        my $new_d = $d*$cnt;
        for (@counts.kv) -> $size, $f
        {
            if $f > 0
            {
                my @c = @counts;
                @c[$size]--;
                for $size ^.. 4 -> $s
                {
                    @c[$s]++;
                }
                rec( $n*$f, $new_d, @c, $new_r );
            }
        }
    }
    return;
}

rec(1, 1, [1],0);

say ($sum - 2).fmt("%.6f");

# vim: expandtab shiftwidth=4 ft=perl6
